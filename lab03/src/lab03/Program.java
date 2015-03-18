package lab03;

import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map.Entry;

public class Program {
	public static HashMap<String, Method> setupMethods = new HashMap<String, Method>();
	public static ArrayList<Method> testMethods = new ArrayList<Method>();

	public static void main(String[] args) throws Exception {
		int passed = 0, failed = 0;
		Method[] declaredMethods = Class.forName("lab03." + args[0]).getDeclaredMethods();

		for (Method m : declaredMethods) {
			if (m.isAnnotationPresent(Setup.class)) {
				setupMethods.put(m.getAnnotation(Setup.class).value(), m);
			} else if (m.isAnnotationPresent(Test.class)) {
				testMethods.add(m);
			}
		}

		for (Method testMethod : testMethods) {
			String values[] = testMethod.getAnnotation(Test.class).value();
			ArrayList<String> setupValues = new ArrayList<String>(Arrays.asList(values));

			for (String value : setupValues) {
				if (value.equals("*")) {
					try {
						for (Entry<String, Method> entry : setupMethods.entrySet()) {
							entry.getValue().setAccessible(true);
							entry.getValue().invoke(null);
						}
						testMethod.setAccessible(true);
						testMethod.invoke(null);
						passed++;
						System.out.println("Test " + testMethod.toString() + " OK!");
					} catch (Throwable ex) {
						failed++;
						System.out.println("Test " + testMethod.toString() + " failed!");
					}
				} else {
					Method setupMethod = setupMethods.get(value);
					try {
						setupMethod.setAccessible(true);
						setupMethod.invoke(null);
						System.out.println("Setup " + value + " ok");
					} catch (Exception e) {
						System.out.println("Setup " + value + " failed");
					}
				}
			}
		}

		/*for (Method m : declaredMethods) {
			if (m.isAnnotationPresent(Test.class)) {
				String[] values = m.getAnnotation(Test.class).value();
				for (int i = 0; i < values.length; i++) {
					System.out.println(m.getName() + " " + i + " " + values[i]);
					if (values[i].equals("*")) {
						
					} else {
						Method method = setupMethods.get(values[i]);
						try {
							method.setAccessible(true);
							method.invoke(null);
						} catch (Throwable ex) {
							System.out.println("Method " + method.toString()
									+ " failed!");
						}
					}
				}

			}
		}*/
		System.out.printf("Passed: %d, Failed %d%n", passed, failed);
	}
}
