package lab03;

import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.Map.Entry;

public class Program {
	public static HashMap<String, Method> hash = new HashMap<String, Method>();

	public static void main(String[] args) throws Exception {
		int passed = 0, failed = 0;

		for (Method m : Class.forName("lab03." + args[0]).getDeclaredMethods()) {
			if (m.isAnnotationPresent(Setup.class)) {
				hash.put(m.getAnnotation(Setup.class).value(), m);
			}
		}

		for (Method m : Class.forName("lab03." + args[0]).getDeclaredMethods()) {
			if (m.isAnnotationPresent(Test.class)) {
				String[] values = m.getAnnotation(Test.class).value();
				for (int i = 0; i < values.length; i++) {
					if (values[i].equals("*")) {
						try {
							for (Entry<String, Method> entry : hash.entrySet()) {
								entry.getValue().setAccessible(true);
								entry.getValue().invoke(null);
							}
							m.setAccessible(true);
							m.invoke(null);
							passed++;
							System.out.println("Test " + m.toString() + " OK!");
						} catch (Throwable ex) {
							failed++;
							System.out.println("Test " + m.toString() + " failed!");
						}
					} else {
						Method method = hash.get(values[i]);
						try {
							method.setAccessible(true);
							method.invoke(null);
						} catch (Throwable ex) {
							
						}
						
					}
				}
				
			}
		}
		System.out.printf("Passed: %d, Failed %d%n", passed, failed);
	}
}
