package ist.meic.pa;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.HashMap;

import javassist.CtField;

public final class Command {

	//private static Exception exceptionThrown;
	private static Object calledObject = new Object();
	private static ArrayList<CtField> ctFields = new ArrayList<CtField>();
	private static ArrayList<Field> objectFields = new ArrayList<Field>();
	private static ArrayList<Method> callStack = new ArrayList<Method>();
	private static HashMap<Field, Object> objectValues = new HashMap<Field, Object>();
	public static String PATH;

	public static int stateC;

	public Command() {}

	public static void setCtFields(ArrayList<CtField> arrayList){ ctFields = arrayList;}

	/*private static void transformFields() {
		for (CtField ctf : ctFields) {
		    Field f;
			try {
				System.out.println(calledObject.getClass());
//				f = calledObject.getClass().getDeclaredField(ctf.getName());
//				System.out.println("laranjas");
//				f.setAccessible(true);
//				System.out.println("benenes");
//				Object value = f.get(calledObject);
//				objectValues.put(f, value);
			} catch (SecurityException | IllegalArgumentException e) {
				System.out.println("bananas");
				e.printStackTrace();
			}
		}
	}*/

	public static void INFO() {
		System.out.println("---info---");
		String output = "Called Object: " + calledObject.toString() + "\n\t\t"
				+ "Fields: " + ctFields.toString() + "\n\t\t"
				+ "Call Stack:\n" + callStack.toString();
		System.out.println(output);
	}

	public static void THROW() {
		System.out.println("---throw---");
		//throw exceptionThrown;
	}

	public static /*Object*/ void RETURN(Object returnValue) {
		/*Method lastMethodCalled = callStack.get(0);
		return lastMethodCalled; // THIS OBVIOUSLY MAKES NO SENSE*/
		System.out.println("---return---");
	}

	public static Object GET(Object fieldName) throws IllegalArgumentException, IllegalAccessException {
		System.out.println("---get---");

		String field = (String) fieldName;
		for (Field objectField : objectFields) {
			if (objectField.getName().equals(field)) {
				return objectField.get(calledObject);
			}
		}
		return null;
	}

	public static void SET(Object fieldName, Object value) throws IllegalArgumentException, IllegalAccessException {
		String field = (String) fieldName;
		for (Field objectField : objectFields) {
			if (objectField.getName().equals(field)) {
				objectField.set(calledObject, value);
			}
		}

		System.out.println("---set---");
	}

	public static void RETRY() {
		/*try {
			callStack.get(0).invoke(null);
		} catch (IllegalAccessException | IllegalArgumentException
				| InvocationTargetException e) {
			e.printStackTrace();
		}*/
		System.out.println("---retry---");
	}

	public static void startCLI(Object exceptionThrower) throws Throwable {
		System.out.println(exceptionThrower.toString());
		System.out.println(Command.PATH + " askldjalksdf");
		//		calledObject = Class.forName(obj).newInstance();
		//		transformFields();
		while (true) {
			String command = "";
			Object[] args = null;
			Class<?>[] parameterTypes = null;

			printPrompt();

			BufferedReader buffer = new BufferedReader(new InputStreamReader(System.in));

			try {
				String input[] = buffer.readLine().split(" ");
				command = input[0].toUpperCase();

				//command ABORT -- special case
				if (command.equals("ABORT"))
					return;

				int aritySize = input.length - 1;
				if (input.length > 1) {
					args = new Object[aritySize];
					Object[] newArgs = new Object[aritySize];
					System.arraycopy(input, 1, newArgs, 0, aritySize);
					System.arraycopy(newArgs, 0, args, 0, newArgs.length);
				}
				// myLoader.getClass().getProtectionDomain().getPermissions().add(new RuntimePermission("exitVM")); --- SECURITY STUFF FOR SYSTEM.EXIT(0)

				if (args == null) {
					parameterTypes = new Class[0];
					Command.class.getDeclaredMethod(command, parameterTypes).invoke(Command.class.newInstance());
				} else {
					parameterTypes = new Class[aritySize];
					for (int i = 0; i < aritySize; i++) {
						parameterTypes[i] = Object.class;
					}
					Command.class.getDeclaredMethod(command, parameterTypes).invoke(Command.class.newInstance(), args);
				}
			} catch (NoSuchMethodException e) {
				System.out.println("Command \"" + command.toLowerCase() + "\" does not exist");
			}
		}
	}

	private static void printPrompt() {
		System.out.println("DebuggerCLI:> ");
	}

	public static void exceptionCatcher(String methodName, Object[] args, Object o) throws Throwable {
		try {
			Class<?> parameterTypes[] = new Class<?>[] {};
			for (int i = 0; i < args.length; i++) {
				parameterTypes[i] = args[i].getClass();
			}
			o.getClass().getDeclaredMethod(methodName, parameterTypes).invoke(o, args);
		} catch (Exception e) {
			System.out.println(e);
			calledObject = o;
			ist.meic.pa.Command.startCLI(calledObject);
			return;
		}
	}

	public static Object exceptionCatcherWithReturn(String methodName, Object[] args, Object o) throws Throwable {
		Object result = null;
		try {
			Class<?> parameterTypes[] = new Class<?>[] {};
			for (int i = 0; i < args.length; i++) {
				parameterTypes[i] = args[i].getClass();
			}

			result = o.getClass().getDeclaredMethod(methodName, parameterTypes).invoke(o, args);
		} catch (Exception e) {
			System.out.println(e);
			calledObject = o;
			ist.meic.pa.Command.startCLI(calledObject);
		}
		return result;
	}
}
