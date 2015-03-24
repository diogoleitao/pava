package ist.meic.pa;

import java.util.Stack;

import javassist.CannotCompileException;
import javassist.ClassPool;
import javassist.CtClass;
import javassist.CtMethod;
import javassist.Loader;

public class DebuggerCLI {

	private static Stack<ObjectFieldValue> undoTrail = new Stack<ObjectFieldValue>();
	private static CtClass toBeRun;

	public static void main(String[] args) throws Throwable {
		// SETUP OBJECTS
		ClassPool pool = ClassPool.getDefault();
		pool.insertClassPath("./build/classes");
		Loader classLoader = new Loader(pool);
		toBeRun = pool.get(args[0]);

		// INSTRUMENT CLASS
		instrumentClass();

		// EXECUTE MAIN METHOD
		Class<?> runnableClass = classLoader.loadClass(args[0]);
		Object tobeas = runnableClass.newInstance();
		tobeas.getClass().getMethod("main", new Class[] { String[].class }).invoke(null, new Object[] { args });
		startCLI();
	}

	private static void instrumentClass() throws Throwable {
		for (CtClass innerClass : toBeRun.getDeclaredClasses()) {
			// SAVE STATE FOR COMMAND'S INFO METHOD
			for (CtMethod method : innerClass.getDeclaredMethods()) {
				try {
					//method.insertBefore("int state0 = History.currentState");
					method.insertAfter("System.out.println(\"woohoo!\");");
				} catch (CannotCompileException e) {
					e.printStackTrace();
				}
			}
		}
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

	private static void startCLI() {
		System.out.print("DebuggerCLI:> ");
	}
}
