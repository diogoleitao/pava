package ist.meic.pa;

import java.lang.reflect.InvocationTargetException;

import javassist.CannotCompileException;
import javassist.ClassPool;
import javassist.Loader;
import javassist.NotFoundException;
import javassist.Translator;

public class DebuggerCLI {

	@SuppressWarnings("unused")
	private static Loader myLoader;

	/**
	 * @param args 
	 *            The first argument is the Java program to be instrumented; the
	 *            following arguments correspond to the instrumented Java
	 *            program arguments
	 */
	public static void main(String[] args) {

		// SETUP OBJECTS
		Translator translator = new MyTranslator();
		ClassPool pool = ClassPool.getDefault();

		try {
			pool.insertClassPath("./build/classes");

			try {
				Loader classLoader = new Loader(pool);
				myLoader = classLoader;
				classLoader.addTranslator(pool, translator);

				try {
					// CLEAN UP ARGS[]
					String[] newArgs = new String[args.length - 1];
					System.arraycopy(args, 1, newArgs, 0, newArgs.length);

					// EXECUTE MAIN METHOD
					Class<?> runnableClass;
					runnableClass = classLoader.loadClass(args[0]); 

					try {
						Object instance = runnableClass.newInstance();
						instance.getClass().getMethod("main", new Class[] { String[].class }).invoke(null, new Object[] { newArgs });
					} catch (InstantiationException | IllegalAccessException | IllegalArgumentException | NoSuchMethodException e) {
						System.err.println("Main method could not be invoked from " + args[0] + " class with " + ((newArgs.length == 0) ? "no arguments" : "arguments " + newArgs.toString()) +  ". Terminating...");
						return;
					} catch (InvocationTargetException e) {
						System.err.println(e.getTargetException());
					}
				} catch (ClassNotFoundException e) {
					System.err.println("Class " + args[0] + " not found. Terminating...");
					return;
				}
			} catch (CannotCompileException e) {
				System.err.println("Cannot compile instrumented classes, check the templates on the custom Translator. Terminating...");
				return;
			}
		} catch (NotFoundException e) {
			System.err.println("Classpath to be inserted in pool not found. Terminating...");
			return;
		}
	}
}
