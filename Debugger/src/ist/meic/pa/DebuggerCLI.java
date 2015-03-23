package ist.meic.pa;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

import javassist.CannotCompileException;
import javassist.ClassPool;
import javassist.CtClass;
import javassist.NotFoundException;

public class DebuggerCLI {

	public static Command commands;

	public static void main(String[] args) throws	NotFoundException,
													CannotCompileException,
													NoSuchMethodException,
													SecurityException,
													IllegalAccessException,
													IllegalArgumentException,
													InvocationTargetException {
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

	public static void instrumentClass(CtClass ctClass) {

	}

	public static void instantiateCommand() throws	IOException,
													ClassNotFoundException,
													InstantiationException,
													IllegalAccessException {
		BufferedReader buffer = new BufferedReader(new InputStreamReader(System.in));
		buffer.readLine().split(" ");
	}
}
