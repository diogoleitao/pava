package lab01;

public class Program {
	
	public static void main(String args[]) {
		String classname = args[0];
		try {
			Class<?> c = Class.forName("lab01." + classname);
			Message m = (Message) c.newInstance();
			m.say();
		} catch (ClassNotFoundException e) {
			System.out.println("Class not found");
		} catch (InstantiationException e) {
			System.out.println("Instantiation error");
		} catch (IllegalAccessException e) {
			System.out.println("Illegal access error");
		}
	}
}
