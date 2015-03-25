package ist.meic.pa;

import java.lang.reflect.Field;
import java.util.Stack;

public class History {

	public static Stack<ObjectFieldValue> undoTrail = new Stack<ObjectFieldValue>();

	public static void storePrevious(Object object, String className, String fieldName, Object value) {
		undoTrail.push(new ObjectFieldValue(object, className, fieldName, value));
	}

	public static int currentState() {
		return undoTrail.size();
	}

	public static void restoreState(int state) {
		while (undoTrail.size() != state) {
			undoTrail.pop().restore();
		}
	}
}

class ObjectFieldValue {
	private Object object;
	private String className;
	private String fieldName;
	private Object value;
	
	public ObjectFieldValue() {
	}

	public ObjectFieldValue(Object object, String className, String fieldName, Object value) {
		this.object = object;
		this.className = className;
		this.fieldName = fieldName;
		this.value = value;
	}

	public void restore() {
		Field field;
		try {
			field = Class.forName(className).getDeclaredField(fieldName);
			field.setAccessible(true);
			field.set(object, value);
		} catch (NoSuchFieldException | SecurityException | ClassNotFoundException | IllegalArgumentException | IllegalAccessException e) {
			e.printStackTrace();
		}
	}
}
