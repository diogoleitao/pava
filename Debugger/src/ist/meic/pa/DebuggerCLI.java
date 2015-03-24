package ist.meic.pa;

import javassist.ClassPool;
import javassist.Loader;
import javassist.Translator;

public class DebuggerCLI {

	//private static Stack<ObjectFieldValue> undoTrail = new Stack<ObjectFieldValue>();

	public static void main(String[] args) throws Throwable {
		// SETUP OBJECTS
		Translator translator = new MyTranslator();
		ClassPool pool = ClassPool.getDefault();
		pool.insertClassPath("./build/classes");
		Loader classLoader = new Loader(pool);
		classLoader.addTranslator(pool, translator);

		// EXECUTE MAIN METHOD
		Class<?> runnableClass = classLoader.loadClass(args[0]);
		Object instance = runnableClass.newInstance();
		instance.getClass().getMethod("main", new Class[] { String[].class }).invoke(null, new Object[] { args });
		startCLI();
	}
/*
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
	*/

	private static void startCLI() {
		System.out.print("DebuggerCLI:> ");
	}
}
