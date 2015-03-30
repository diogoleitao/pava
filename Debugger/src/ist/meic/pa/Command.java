package ist.meic.pa;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.lang.reflect.Constructor;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.Stack;

public final class Command {

	/**
	 * The last constructor to be invoked that threw an Exception
	 */
	private static Constructor<? extends Object> lastConstructorInvoked = null;

	/**
	 * The called object that threw an Exception
	 */
	private static Object calledObject = null;

	/**
	 * The last method invoked from the previously mentioned object from which
	 * the Expection originated
	 */
	private static Method lastMethodInvoked = null;

	/**
	 * The exception that was thrown by the method invoked
	 */
	private static Throwable exceptionThrown = null;

	/**
	 * The arguments of the last method invoked
	 */
	private static Object[] lastMethodInvokedArguments = null;

	/**
	 * The list of method calls until the Exception was thrown
	 */
	private static Stack<String> callStack = new Stack<String>();

	/**
	 * True if the Return command was invoked to return a custom value; false
	 * otherwise
	 */
	private static boolean customReturn = false;

	/**
	 * The custom return value created with the Return command
	 */
	private static Object customReturnValue = null;

	/**
	 * 
	 */
	private static Stack<Method> methodCallStack = new Stack<Method>();

	/**
	 * Standard constructor for this class
	 */
	public Command() {
	}

	public static void pushMain(String main, Object[] mainArgs) {
		// trim main declaration
		main = main.substring(main.indexOf("void") + 5, main.indexOf("main") + 4);

		// build main arguments string
		String args = "";
		if (mainArgs.length == 0);
		else {
			for (Object arg : mainArgs) {
				args += arg.toString() + ",";
			}
		}

		main += main + "(" + args + ")\n";
	}

	/**
	 * Aborts the current program and terminates the DebuggerCLI application.
	 * Doesn't work when running the DebuggerCLI with Ant (it doesn't have
	 * permission to such call
	 */
	public static void ABORT() {
		System.exit(0);
	}

	/**
	 * Info command; Prints the current object being analized with the following
	 * information: the object itself, its fields and the call stack with each
	 * method's arguments
	 */
	public static void INFO() {
		String objectFields = "";
		String methodCalls = "";

		for (Field f : calledObject.getClass().getDeclaredFields())
			objectFields += f.getName() + ",";
		objectFields = objectFields.substring(0, objectFields.length() - 1);

		for (int i = callStack.size() - 1; i >= 0; i--)
			methodCalls += callStack.get(i);

		String output = "Called Object: " + calledObject.toString() + "\n\t\t"
				+ "Fields: " + objectFields + "\r\rCall Stack:\n\n" + methodCalls;
		System.out.print(output);
	}

	/**
	 * Rethrows the Exception caught to be handled by the next handler
	 *
	 * @throws Throwable
	 */
	public static void THROW() throws Throwable {
		callStack.pop();
		throw exceptionThrown;
	}

	/**
	 * Returns to the last method invoked the parameter given as input,
	 * disregarding the behaviour of said method
	 *
	 * @param returnValue
	 */
	public static void RETURN(Object returnValue) {
		String value = (String) returnValue;
		Class<?> returnType = lastMethodInvoked.getReturnType();

		if (returnType.equals(void.class)) {
			System.err.println("Last method invoked has return type void.");
			return;
		}

		if (returnType.equals(byte.class)) {
			customReturnValue = Byte.parseByte(value);
		} else if (returnType.equals(short.class)) {
			customReturnValue = Short.parseShort(value);
		} else if (returnType.equals(int.class)) {
			customReturnValue = Integer.parseInt(value);
		} else if (returnType.equals(long.class)) {
			customReturnValue = Long.parseLong(value);
		} else if (returnType.equals(float.class)) {
			customReturnValue = Float.parseFloat(value);
		} else if (returnType.equals(double.class)) {
			customReturnValue = Double.parseDouble(value);
		} else if (returnType.equals(char.class)) {
			customReturnValue = value.charAt(0);
		} else if (returnType.equals(boolean.class)) {
			customReturnValue = Boolean.parseBoolean(value);
		} else {
			customReturnValue = returnValue;
		}
	}

	/**
	 * Prints the value of a field from the current object, if it exists, with
	 * its name given as input
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
	 * Sets the field <i>fieldName</i> with value <i>value</i>, both given as
	 * input. The value is casted down before being assigned to the field.
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
	 * Re-run the program being instrumented again
	 *
	 * @throws IllegalAccessException
	 * @throws IllegalArgumentException
	 * @throws InvocationTargetException
	 */
	public static void RETRY() throws IllegalAccessException, IllegalArgumentException, InvocationTargetException {
		
	}

	/**
	 * Starts the command line interface loop. Firstly, it reads the command an
	 * possible arguments given as input; Secondly, if it's the <i>Abort</i>
	 * command, then it immediatly exits the DebuggerCLI; if not, then it tries
	 * to invoke the given command as a method on this class with the given
	 * arguments, if there are any.
	 *
	 * @throws Throwable
	 */
	public static void startCLI(String m, Object[] a, Object o, Class<?>[] p, Throwable e, boolean isConstructor) throws Throwable {

		// update necessary fields
		if (isConstructor) 
			lastConstructorInvoked = o.getClass().getDeclaredConstructor(p);
		else
			lastMethodInvoked = o.getClass().getDeclaredMethod(m, p);

		lastMethodInvokedArguments = a;
		calledObject = o;
		exceptionThrown = e;

		while (true) {
			String command = "";
			Object[] args = null;
			Class<?>[] parameterTypes = null;

			printPrompt();

			BufferedReader buffer = new BufferedReader(new InputStreamReader(System.in));

			try {
				String input[] = buffer.readLine().split(" ");
				command = input[0].toUpperCase();

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
			} catch (IOException e1) {
				System.err.println("IO error.");
			} catch (IllegalAccessException e1) {
				System.err.println("Cannot access class instance.");
			} catch (IllegalArgumentException e1) {
				System.err.println("The arguments are illegal/invalid.");
			} catch (NoSuchMethodException e1) {
				System.err.println("Command \"" + command.toLowerCase() + "\" does not exist. / Wrong number of arguments.");
			} catch (SecurityException e1) {
				System.err.println("Security exception.");
			} catch (InstantiationException e1) {
				System.err.println("Cannot instatiate Command class.");
			} catch (InvocationTargetException e1) {
				throw e1.getTargetException();
			}
		}
	}

	/**
	 * Prints the CLI prompt
	 */
	private static void printPrompt() {
		System.out.println("DebuggerCLI:> ");
	}
	/*
	/**
	 * @param methodName
	 * @param methodArgs
	 * @param invokedObject
	 * @throws Throwable
	 *
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

			String args = "";
			boolean hasMoreThanOne = false;
			for (Object arg : methodArgs) {
				switch (methodArgs.length) {
				case 0:
					args = "";
					break;
				case 1:
					args = arg.toString();
					break;
				default:
					args += arg.toString() + ",";
					hasMoreThanOne = true;
					break;
				}
			}

			if (hasMoreThanOne)
				args = args.substring(0, args.length() - 1);

			lastMethodInvokedArguments = methodArgs;
			boolean javaMethod = invokedObject.getClass().getName().contains("java."); 

			if (!javaMethod)
				callStack.push(invokedObject.getClass().getName() + "." + methodName + "(" + args + ")\n");

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
	 */
	/**
	 * @param constructorName
	 * @param constructorArgs
	 * @param invokedObject
	 * @throws Throwable
	 */
	public static void exceptionCatcherConstructor(String constructorName, Object[] constructorArgs, Object invokedObject) throws Throwable {
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

		try {
			lastConstructorInvoked = invokedObject.getClass().getDeclaredConstructor(parameterTypes);
			lastConstructorInvoked.newInstance(constructorArgs);
		} catch (InvocationTargetException e) {
			System.out.println(e.getTargetException());
			ist.meic.pa.Command.startCLI(constructorName, constructorArgs, invokedObject, parameterTypes, e.getTargetException(), true);
			return;
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * @param methodName
	 * @param methodArgs
	 * @param invokedObject
	 * @return
	 * @throws Throwable
	 */
	public static Object exceptionCatcherWithReturn(String methodName, Object[] methodArgs, Object invokedObject) throws Throwable {
		Object result = null;
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
		try {
			boolean javaMethod = invokedObject.getClass().getName().contains("java.");
			if (!javaMethod) {
				String args = "";
				boolean hasMoreThanOne = false;
				for (Object arg : methodArgs) {
					switch (methodArgs.length) {
					case 0:
						args = "";
						break;
					case 1:
						args = arg.toString();
						break;
					default:
						args += arg.toString() + ",";
						hasMoreThanOne = true;
						break;
					}
				}

				if (hasMoreThanOne)
					args = args.substring(0, args.length() - 1);
				callStack.push(invokedObject.getClass().getName() + "." + methodName + "(" + args + ")\n");
				methodCallStack.push(invokedObject.getClass().getDeclaredMethod(methodName, parameterTypes));
			}

			result = invokedObject.getClass().getDeclaredMethod(methodName, parameterTypes).invoke(invokedObject, methodArgs);
		} catch (InvocationTargetException e) {
			System.out.println(e.getTargetException());
			ist.meic.pa.Command.startCLI(methodName, methodArgs, invokedObject, parameterTypes, e.getTargetException(), false);
		} catch (Exception e) {
			e.printStackTrace();
		}

		if (customReturn) {
			customReturn = false;
			return customReturnValue;
		} else {
			return result;
		}
	}
}
