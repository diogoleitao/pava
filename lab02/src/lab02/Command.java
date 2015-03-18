package lab02;

public class Command {

	public static Object getInstance(Object className) {
		try {
			Object obj = Class.forName((String) className).newInstance();
			System.out.println(obj.getClass());
			return obj;
		} catch (InstantiationException | IllegalAccessException | ClassNotFoundException e) {
			e.printStackTrace();
			return null;
		}
	}
	
	public static void saveObject(Object className) {
		System.out.println("Saved name for object of type: class java.lang.Class");
	}
	
	public static Object selectObject(Object className) {
		return null;
	}
	
	public static Object selectFromArray(Object index) {
		return null;
	}
}
