package ist.meic.pa;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.lang.reflect.Constructor;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

public final class Command {

	private static Throwable exceptionThrown;
	private static Method lastMethodInvoked;
	private static Constructor<? extends Object> lastConstructorInvoked;
	private static Object calledObject;
	private static Object[] args;
	private static String callStack = "\n";

	public Command() {}

	public static void INFO() {
		String fields = "";
		for (Field f: calledObject.getClass().getDeclaredFields())
			fields += f.getName() + "\n\t\t";
		String output = "Called Object: " + calledObject.toString() + "\n\t\t"
					  + "Fields: " + fields
					  + "\r\rCall Stack:\n" + callStack;
		System.out.println(output);
	}

	public static void THROW() throws Throwable {
		throw exceptionThrown;
	}

	public static /*Object*/ void RETURN(Object returnValue) {
		/*Method lastMethodCalled = callStack.get(0);
		return lastMethodCalled; // THIS OBVIOUSLY MAKES NO SENSE*/
		System.out.println("---return---");
	}

	public static void GET(Object fieldName) {
		try {
			String field = (String) fieldName;
			for (Field objectField : calledObject.getClass().getDeclaredFields()) {
				objectField.setAccessible(true);
				if (objectField.getName().equals(field))
					System.out.println(objectField.get(calledObject));
			}
		} catch (IllegalArgumentException e) {
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		}
	}

	public static void SET(Object fieldName, Object value) {
		System.out.println("---set---");

		try {
			String field = (String) fieldName;
			for (Field objectField : calledObject.getClass().getDeclaredFields()) {
				objectField.setAccessible(true);
				if (objectField.getName().equals(field)) {
					System.out.println(objectField.getType());
					if (objectField.getType().toString().equals("int")) {
						int val = Integer.parseInt(value.toString());
						objectField.set(calledObject, val);
					} else if (objectField.getType().toString().equals("double")) {
						double val = Double.parseDouble(value.toString());
						objectField.set(calledObject, val);
					} else if (objectField.getType().toString().equals("float")) {
						float val = Float.parseFloat(value.toString());
						objectField.set(calledObject, val);
					} else if (objectField.getType().toString().equals("long")) {
						long val = Long.parseLong(value.toString());
						objectField.set(calledObject, val);
					} else if (objectField.getType().toString().equals("char")) {
						char val = value.toString().charAt(0);
						objectField.set(calledObject, val);
					} else if (objectField.getType().toString().equals("short")) {
						short val = Short.parseShort(value.toString());
						objectField.set(calledObject, val);
					} else if (objectField.getType().toString().equals("boolean")) {
						boolean val = Boolean.parseBoolean(value.toString());
						objectField.set(calledObject, val);
					} else if (objectField.getType().toString().equals("byte")) {
						byte val = Byte.parseByte(value.toString());
						objectField.set(calledObject, val);
					} else {
						objectField.set(calledObject, value);
					}
				}
			}
		} catch (SecurityException e) {
			e.printStackTrace();
		} catch (IllegalArgumentException e) {
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		}
	}

	public static void RETRY() throws IllegalAccessException, IllegalArgumentException, InvocationTargetException {
		System.out.println("---retry---");
		lastMethodInvoked.invoke(calledObject, args);
	}

	public static void startCLI(Object exceptionThrower) throws Throwable {
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
					System.exit(0);

				int aritySize = input.length - 1;
				if (input.length > 1) {
					args = new Object[aritySize];
					Object[] newArgs = new Object[aritySize];
					System.arraycopy(input, 1, newArgs, 0, aritySize);
					System.arraycopy(newArgs, 0, args, 0, newArgs.length);
				}

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
			Class<?> parameterTypes[] = new Class<?>[args.length];
			for (int i = 0; i < args.length; i++)
				parameterTypes[i] = args[i].getClass();

			// CONVERT ARGS TYPE TO PRIMITIVE ONES
			for (int i = 0; i < parameterTypes.length; i++) {
				if (parameterTypes[i].getName().equals("java.lang.Integer")) {
					parameterTypes[i] = int.class;
				} else if (parameterTypes[i].getName().equals("java.lang.Double")) {
					parameterTypes[i] = double.class;
				} else if (parameterTypes[i].getName().equals("java.lang.Float")) {
					parameterTypes[i] = float.class;
				} else if (parameterTypes[i].getName().equals("java.lang.Long")) {
					parameterTypes[i] = long.class;
				} else if (parameterTypes[i].getName().equals("java.lang.Character")) {
					parameterTypes[i] = char.class;
				} else if (parameterTypes[i].getName().equals("java.lang.Short")) {
					parameterTypes[i] = short.class;
				} else if (parameterTypes[i].getName().equals("java.lang.Boolean")) {
					parameterTypes[i] = boolean.class;
				} else if (parameterTypes[i].getName().equals("java.lang.Byte")) {
					parameterTypes[i] = byte.class;
				}
			}

			callStack += o.getClass().getName() + "." + methodName + args.toString() + "\n";
			lastMethodInvoked = o.getClass().getDeclaredMethod(methodName, parameterTypes); 
			lastMethodInvoked.invoke(o, args);
		} catch (InvocationTargetException e) {
			System.out.println(1);
			calledObject = o;
			exceptionThrown = e.getTargetException();
			System.out.println(e.getTargetException());
			ist.meic.pa.Command.startCLI(calledObject);
			return;
		} catch (Exception e) {
			e.printStackTrace();
		}
	}	
	
	public static void exceptionCatcherConstructor(String constructorName, Object[] args, Object o) throws Throwable {
		try {
			Class<?> parameterTypes[] = new Class<?>[args.length];
			for (int i = 0; i < args.length; i++)
				parameterTypes[i] = args[i].getClass();

			// CONVERT ARGS TYPE TO PRIMITIVE ONES
			for (int i = 0; i < parameterTypes.length; i++) {
				if (parameterTypes[i].getName().equals("java.lang.Integer")) {
					parameterTypes[i] = int.class;
				} else if (parameterTypes[i].getName().equals("java.lang.Double")) {
					parameterTypes[i] = double.class;
				} else if (parameterTypes[i].getName().equals("java.lang.Float")) {
					parameterTypes[i] = float.class;
				} else if (parameterTypes[i].getName().equals("java.lang.Long")) {
					parameterTypes[i] = long.class;
				} else if (parameterTypes[i].getName().equals("java.lang.Character")) {
					parameterTypes[i] = char.class;
				} else if (parameterTypes[i].getName().equals("java.lang.Short")) {
					parameterTypes[i] = short.class;
				} else if (parameterTypes[i].getName().equals("java.lang.Boolean")) {
					parameterTypes[i] = boolean.class;
				} else if (parameterTypes[i].getName().equals("java.lang.Byte")) {
					parameterTypes[i] = byte.class;
				}
			}

			callStack += o.getClass().getName() + "." + constructorName + args.toString() + "\n";
			lastConstructorInvoked = o.getClass().getDeclaredConstructor(parameterTypes);
			lastConstructorInvoked.newInstance(args); //since we cannot invoke is it new instance?
		} catch (InvocationTargetException e) {
			System.out.println(1);
			calledObject = o;
			exceptionThrown = e.getTargetException();
			System.out.println(e.getTargetException());
			ist.meic.pa.Command.startCLI(calledObject);
			return;
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static Object exceptionCatcherWithReturn(String methodName, Object[] args, Object o) throws Throwable {
		Object result = null; 
		try {
			Class<?> parameterTypes[] = new Class<?>[args.length];
			for (int i = 0; i < args.length; i++)
				parameterTypes[i] = args[i].getClass();

			// CONVERT ARGS TYPE TO PRIMITIVE ONES
			for (int i = 0; i < parameterTypes.length; i++) {
				if (parameterTypes[i].getName().equals("java.lang.Integer")) {
					parameterTypes[i] = int.class;
				} else if (parameterTypes[i].getName().equals("java.lang.Double")) {
					parameterTypes[i] = double.class;
				} else if (parameterTypes[i].getName().equals("java.lang.Float")) {
					parameterTypes[i] = float.class;
				} else if (parameterTypes[i].getName().equals("java.lang.Long")) {
					parameterTypes[i] = long.class;
				} else if (parameterTypes[i].getName().equals("java.lang.Character")) {
					parameterTypes[i] = char.class;
				} else if (parameterTypes[i].getName().equals("java.lang.Short")) {
					parameterTypes[i] = short.class;
				} else if (parameterTypes[i].getName().equals("java.lang.Boolean")) {
					parameterTypes[i] = boolean.class;
				} else if (parameterTypes[i].getName().equals("java.lang.Byte")) {
					parameterTypes[i] = byte.class;
				}
			}

			callStack += o.getClass().getName() + "." + methodName + args.toString() + "\n";
			lastMethodInvoked = o.getClass().getDeclaredMethod(methodName, parameterTypes); 
			result = lastMethodInvoked.invoke(o, args);
		} catch (InvocationTargetException e) {
			System.out.println(2);
			calledObject = o;
			exceptionThrown = e.getTargetException();
			System.out.println(e.getTargetException());
			ist.meic.pa.Command.startCLI(calledObject);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
}
