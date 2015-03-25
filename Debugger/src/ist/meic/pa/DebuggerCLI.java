package ist.meic.pa;

import javassist.ClassPool;
import javassist.Loader;
import javassist.Translator;

public class DebuggerCLI {

	@SuppressWarnings("unused")
	private static Loader myLoader;

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
	}
}
