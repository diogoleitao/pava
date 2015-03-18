package ist.meic.pa;

import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.ArrayList;

import javassist.CannotCompileException;
import javassist.ClassPool;
import javassist.CtClass;
import javassist.NotFoundException;

/**
 * @author Diogo
 *
 */
public class DebuggerCLI {

	public static Object calledObject;

	public static ArrayList<Field> objectFields;

	public static ArrayList<Method> callStack;

	@SuppressWarnings("serial")
	public static ArrayList<String> commands = new ArrayList<String>() {
		{
			add("Abort");
			add("Info");
			add("Throw");
			add("Return");
			add("Get");
			add("Set");
			add("Retry");
		}
	};

	/**
	 * @param args
	 * @throws NotFoundException
	 * @throws CannotCompileException
	 * @throws SecurityException
	 * @throws NoSuchMethodException
	 * @throws InvocationTargetException 
	 * @throws IllegalArgumentException 
	 * @throws IllegalAccessException 
	 */
	public static void main(String[] args) throws NotFoundException, CannotCompileException, NoSuchMethodException, SecurityException, IllegalAccessException, IllegalArgumentException, InvocationTargetException {
		ClassPool pool = ClassPool.getDefault();
		CtClass ctClass = pool.get(args[0]);

		instrumentClass(ctClass);

		Class<?> rtClass = ctClass.toClass();
		Method main = rtClass.getMethod("main", args.getClass());

		String[] restArgs = new String[args.length - 2];
		System.arraycopy(args, 2, restArgs, 0, restArgs.length);

		try {
			main.invoke(null, new Object[] { restArgs });
		} catch (Exception e) {
			System.out.println(e.getCause());
		}
	}

	/**
	 * @param ctClass
	 */
	public static void instrumentClass(CtClass ctClass) {

	}
}
