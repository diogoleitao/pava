package ist.meic.pa;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.Stack;

import javassist.ClassPool;
import javassist.Loader;
import javassist.Translator;

public class DebuggerCLI {

	private static Command commands = new Command();
	private static Loader myLoader;

	private static Stack<ObjectFieldValue> undoTrail = new Stack<ObjectFieldValue>();

	public static void main(String[] args) throws Throwable {
		// SETUP OBJECTS
		Translator translator = new MyTranslator();
		ClassPool pool = ClassPool.getDefault();
		pool.insertClassPath("./build/classes");
		Loader classLoader = new Loader(pool);
		myLoader = classLoader;
		classLoader.addTranslator(pool, translator);

		// CLEAN UP ARGS[]
		String[] newArgs = new String[args.length - 1];
		System.arraycopy(args, 1, newArgs, 0, newArgs.length);

		// EXECUTE MAIN METHOD
		Class<?> runnableClass = classLoader.loadClass(args[0]);
		Object instance = runnableClass.newInstance();
		instance.getClass().getMethod("main", new Class[] { String[].class }).invoke(null, new Object[] { newArgs });
		startCLI();
	}

	public static void startCLI() throws Throwable {
		while (true) {
			String command = "";
			Object[] args = null;
			Class<?>[] parameterTypes = null;

			printPrompt();

			BufferedReader buffer = new BufferedReader(new InputStreamReader(System.in));

			try {
				String input[] = buffer.readLine().split(" ");
				command = input[0].toUpperCase();
				if (command.equals(""))
					return;

				if (input.length > 1) {
					int length = input.length - 1;
					args = new Object[length];
					Object[] newArgs = new Object[length];
					System.arraycopy(input, 1, newArgs, 0, length);
					System.arraycopy(newArgs, 0, args, 0, newArgs.length);
				}
				// myLoader.getClass().getProtectionDomain().getPermissions().add(new RuntimePermission("exitVM")); --- SECURITY STUFF FOR SYSTEM.EXIT(0)

				if (args == null) {
					parameterTypes = new Class[0];
					commands.getClass().getDeclaredMethod(command, parameterTypes).invoke(commands.getClass().newInstance());
				} else {
					parameterTypes = new Class[1];
					parameterTypes[0] = Object.class;
					commands.getClass().getDeclaredMethod(command, parameterTypes).invoke(commands.getClass().newInstance(), args);
				}
			} catch (NoSuchMethodException e) {
				System.out.println("Command \"" + command.toLowerCase()
						+ "\" does not exist");
			}
		}
	}

	private static void printPrompt() {
		System.out.println("DebuggerCLI:> ");
	}
	
	private static void storePrevious(Object object, String className, String fieldName, Object value) {
		undoTrail.push(new ObjectFieldValue(object, className, fieldName, value));
	}

	private static int currentState() {
		return undoTrail.size();
	}

	private static void restoreState(int state) {
		while (undoTrail.size() != state) {
			undoTrail.pop().restore();
		}
	}
}
