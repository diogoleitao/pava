package ist.meic.pa;

import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.ArrayList;

public class Command {

	private Exception exceptionThrown;
	private Object calledObject = new Object();
	private ArrayList<Field> objectFields = new ArrayList<Field>();
	private ArrayList<Method> callStack = new ArrayList<Method>();

	public Command() {}

	public Command(Object calledObject, ArrayList<Field> objectFields,
			ArrayList<Method> callStack) {
		this.calledObject = calledObject;
		this.objectFields = objectFields;
		this.callStack = callStack;
	}

	public void ABORT() {
		System.out.println("---abort---");
		//System.exit(0);
		return;
	}

	public void INFO() {
		System.out.println("---info---");
		String output = "Called Object: " + calledObject.toString() + "\n\t\t"
				+ "Fields: " + objectFields.toString() + "\n\t\t"
				+ "Call Stack:\n" + callStack.toString();
		System.out.println(output);
	}

	public void THROW() {
		System.out.println("---throw---");
		//throw exceptionThrown;
	}

	public /*Object*/ void RETURN(Object returnValue) {
		/*Method lastMethodCalled = callStack.get(0);
		return lastMethodCalled; // THIS OBVIOUSLY MAKES NO SENSE*/
		System.out.println("---return---");
	}

	public Object GET(Object fieldName) throws IllegalArgumentException, IllegalAccessException {
		System.out.println("---get---");

		String field = (String) fieldName;
		for (Field objectField : objectFields) {
			if (objectField.getName().equals(field)) {
				return objectField.get(calledObject);
			}
		}
		return null;
	}

	public void SET(Object fieldName, Object value) throws IllegalArgumentException, IllegalAccessException {
		String field = (String) fieldName;
		for (Field objectField : objectFields) {
			if (objectField.getName().equals(field)) {
				objectField.set(calledObject, value);
			}
		}

		System.out.println("---set---");
	}

	public void RETRY() {
		/*try {
			callStack.get(0).invoke(null);
		} catch (IllegalAccessException | IllegalArgumentException
				| InvocationTargetException e) {
			e.printStackTrace();
		}*/
		System.out.println("---retry---");
	}
}
