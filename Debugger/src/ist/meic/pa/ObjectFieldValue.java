package ist.meic.pa;

import java.lang.reflect.Field;

public class ObjectFieldValue {
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
