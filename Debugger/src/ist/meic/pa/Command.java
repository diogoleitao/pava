package ist.meic.pa;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.ArrayList;

public final class Command {

	//private static Exception exceptionThrown;
	private static Object calledObject = new Object();
	private static ArrayList<Field> objectFields = new ArrayList<Field>();
	private static ArrayList<Method> callStack = new ArrayList<Method>();

	public static int stateC;

	public Command() {}

	public Command(Object calledObject, ArrayList<Field> objectFields,
			ArrayList<Method> callStack) {
		Command.calledObject = calledObject;
		Command.objectFields = objectFields;
		Command.callStack = callStack;
	}

	public static void ABORT() {
		System.out.println("---abort---");
		System.out.println(stateC);
		//Runtime.getRuntime().exit(0);
	}

	public static void INFO() {
		System.out.println("---info---");
		String output = "Called Object: " + calledObject.toString() + "\n\t\t"
				+ "Fields: " + objectFields.toString() + "\n\t\t"
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
}
