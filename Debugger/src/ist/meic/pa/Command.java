package ist.meic.pa;

import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.lang.reflect.Type;
import java.util.ArrayList;

public class Command {
	private Object calledObject = new Object();

	private ArrayList<Field> objectFields = new ArrayList<Field>();

	private ArrayList<Method> callStack = new ArrayList<Method>();

	public Command(Object calledObject, ArrayList<Field> objectFields, ArrayList<Method> callStack) {
		this.calledObject = calledObject;
		this.objectFields = objectFields;
		this.callStack = callStack;
	}

	public void Abort() {
		
	}

	public void Info() {
		String output = "Called Object: " + calledObject.toString() + "\n\t\t" + 
								"Fields: " + objectFields.toString() + "\n\t\t" + 
						"Call Stack:\n" + callStack.toString();
		System.out.println(output);
	}

	public void Throw() {
		
	}

	public Object Return(Type returnValue) {
		Class<?> returnType = callStack.get(0).getReturnType();
		
		
		return null;
	}

	public Object Get(String fieldName) throws IllegalArgumentException, IllegalAccessException {
		for (Field field : objectFields) {
			if (field.getName().equals(fieldName)) {
				return field.get(calledObject);
			}
		}
		return null;
	}

	public void Set(String fieldName, Object value) throws IllegalArgumentException, IllegalAccessException {
		for (Field field : objectFields) {
			if (field.getName().equals(fieldName)) {
				field.set(calledObject, value);
			}
		}
	}

	public void Retry() {
		
	}
}
