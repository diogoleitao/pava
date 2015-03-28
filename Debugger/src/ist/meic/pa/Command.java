package ist.meic.pa;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.lang.reflect.Constructor;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

public final class Command {

	/**
	 * The last constructor to be invoked that threw an Exception
	 */
	private static Constructor<? extends Object> lastConstructorInvoked;

	/**
	 * The called object that threw an Exception
	 */
	private static Object calledObject;

	/**
	 * The last method invoked from the previously mentioned object
	 * from which the Expection originated
	 */
	private static Method lastMethodInvoked;

	/**
	 * The exception that was thrown by the method invoked
	 */
	private static Throwable exceptionThrown;

	/**
	 * The arguments of the last method invoked
	 */
	private static Object[] args;

	/**
	 * The list of method calls until the Exception was thrown
	 */
	private static String callStack = "\n";

	/**
	 * Standard constructor for this class
	 */
	public Command() {}

	/**
	 * Info command; Prints the current object being analized with
	 * the following information: the object itself, its fields and
	 * the call stack with each method's arguments
	 */
	public static void INFO() {
		String fields = "";
		for (Field f: calledObject.getClass().getDeclaredFields())
			fields += f.getName() + "\n\t\t";
		String output = "Called Object: " + calledObject.toString() + "\n\t\t"
				+ "Fields: " + fields
				+ "\r\rCall Stack:\n" + callStack;
		System.out.print(output);
	}

	/**
	 * Rethrows the Exception caught to be handled by the next handler
	 *
	 * @throws Throwable
	 */
	public static void THROW() throws Throwable {
		throw exceptionThrown;
	}

	/**
	 * Returns to the last method invoked the parameter given as
	 * input, disregarding the behaviour of said method
	 *
	 * @param returnValue
	 */
	public static /*Object*/ void RETURN(Object returnValue) {
		/*Method lastMethodCalled = callStack.get(0);
		return lastMethodCalled; // THIS OBVIOUSLY MAKES NO SENSE*/
		System.out.println("---return---");
	}

	/**
	 * Prints the value of a field from the current object,
	 * if it exists, with its name given as input
	 *
	 * @param fieldName
	 */
	public static void GET(Object fieldName) {
		String field = (String) fieldName;
		try {
			for (Field objectField : calledObject.getClass().getDeclaredFields()) {
				objectField.setAccessible(true);
				if (objectField.getName().equals(field))
					System.out.println(objectField.get(calledObject));
			}
		} catch (IllegalArgumentException e) {
			System.err.println("The name passed as argument is illegal/inappropriate.");
		} catch (IllegalAccessException e) {
			System.err.println("Cannot access the field " + field + ".");
		}
	}

	/**
	 * Sets the field <i>fieldName</i> with value <i>value</i>,
	 * both given as input. The value is casted down before
	 * being assigned to the field.
	 *
	 * @param fieldName
	 * @param value
	 */
	public static void SET(Object fieldName, Object value) {
		String field = (String) fieldName;
		try {
			for (Field objectField : calledObject.getClass().getDeclaredFields()) {
				objectField.setAccessible(true);
				if (objectField.getName().equals(field)) {
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
			System.err.println("Security exception.");
		} catch (IllegalArgumentException e) {
			System.err.println("The arguments passed in are illegal/inappropriate.");
		} catch (IllegalAccessException e) {
			System.err.println("Cannot access the field " + field + ".");
		}
	}

	/**
	 *
	 *
	 * @throws IllegalAccessException
	 * @throws IllegalArgumentException
	 * @throws InvocationTargetException
	 */
	public static void RETRY() throws IllegalAccessException, IllegalArgumentException, InvocationTargetException {
		lastMethodInvoked.invoke(calledObject, args);
	}

	/**
	 * Starts the command line interface loop.
	 * Firstly, it reads the command an possible arguments given as input;
	 * Secondly, if it's the <i>Abort</i> command, then it immediatly exits
	 * the DebuggerCLI; if not, then it tries to invoke the given command
	 * as a method on this class with the given arguments, if there are any.
	 *
	 * @throws Throwable
	 */
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
					for (int i = 0; i < aritySize; i++)
						parameterTypes[i] = Object.class;
					Command.class.getDeclaredMethod(command, parameterTypes).invoke(Command.class.newInstance(), args);
				}
			} catch (IOException e) {
				System.err.println("IO error.");
			} catch (IllegalAccessException e) {
				System.err.println("Cannot access class instance.");
			} catch (IllegalArgumentException e) {
				System.err.println("The arguments are illegal/invalid.");
			} catch (NoSuchMethodException e) {
				System.err.println("Command \"" + command.toLowerCase() + "\" does not exist. / Wrong number of arguments.");
			} catch (SecurityException e) {
				System.err.println("Security exception.");
			} catch (InstantiationException e) {
				System.err.println("Cannot instatiate Command class.");
			} catch(InvocationTargetException e) {
				throw e.getTargetException();
			}
		}
	}

	/**
	 * Print the CLI prompt
	 */
	private static void printPrompt() {
		System.out.println("DebuggerCLI:> ");
	}

	public static void exceptionCatcher(String methodName, Object[] methodArgs, Object invokedObject) throws Throwable {
		try {
			Class<?> parameterTypes[] = new Class<?>[methodArgs.length];
			for (int i = 0; i < methodArgs.length; i++)
				parameterTypes[i] = methodArgs[i].getClass();

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

			callStack += invokedObject.getClass().getName() + "." + methodName + methodArgs.toString() + "\n";
			lastMethodInvoked = invokedObject.getClass().getDeclaredMethod(methodName, parameterTypes);
			lastMethodInvoked.invoke(invokedObject, methodArgs);
		} catch (InvocationTargetException e) {
			calledObject = invokedObject;
			exceptionThrown = e.getTargetException();
			System.err.println(exceptionThrown);
			ist.meic.pa.Command.startCLI();
			return;
		} catch (Exception e) {
			System.err.println(e);
		}
	}

	public static void exceptionCatcherConstructor(String constructorName, Object[] constructorArgs, Object invokedObject) throws Throwable {
		try {
			Class<?> parameterTypes[] = new Class<?>[constructorArgs.length];
			for (int i = 0; i < constructorArgs.length; i++)
				parameterTypes[i] = constructorArgs[i].getClass();

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

			callStack += invokedObject.getClass().getName() + "." + constructorName + constructorArgs.toString() + "\n";
			lastConstructorInvoked = invokedObject.getClass().getDeclaredConstructor(parameterTypes);
			lastConstructorInvoked.newInstance(constructorArgs);
		} catch (InvocationTargetException e) {
			calledObject = invokedObject;
			exceptionThrown = e.getTargetException();
			System.out.println(exceptionThrown);
			ist.meic.pa.Command.startCLI();
			return;
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static Object exceptionCatcherWithReturn(String methodName, Object[] methodArgs, Object invokedObject) throws Throwable {
		Object result = null;
		try {
			Class<?> parameterTypes[] = new Class<?>[methodArgs.length];
			for (int i = 0; i < methodArgs.length; i++)
				parameterTypes[i] = methodArgs[i].getClass();

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

			callStack += invokedObject.getClass().getName() + "." + methodName + methodArgs.toString() + "\n";
			lastMethodInvoked = invokedObject.getClass().getDeclaredMethod(methodName, parameterTypes);
			result = lastMethodInvoked.invoke(invokedObject, methodArgs);
		} catch (InvocationTargetException e) {
			calledObject = invokedObject;
			exceptionThrown = e.getTargetException();
			System.out.println(exceptionThrown);
			ist.meic.pa.Command.startCLI();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
}
