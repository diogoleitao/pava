package lab02;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.HashMap;

public class Program {

	@SuppressWarnings("serial")
	private static HashMap<String, String> commands = new HashMap<String, String>() {
		{
			put("Class", "getInstance");
			put("Set", "saveObject");
			put("Get", "selectObject");
			put("Index", "selectFromArray");
		}
	};

	public static void main(String[] args) {
		Object result = new Object();

		System.out.println("Command:> ");

		BufferedReader buffer = new BufferedReader(new InputStreamReader(System.in));
		try {
			String input = buffer.readLine();
			String command = input.split(" ")[0];
			Object arg = input.split(" ")[1];

			for (String c : commands.keySet()) {
				if (command.equals(c)) {
					try {
						Method m = Command.class.getMethod(commands.get(c), Object.class);
						try {
							result = m.invoke(Command.class, arg);
						} catch (IllegalAccessException | IllegalArgumentException | InvocationTargetException e) {
							e.printStackTrace();
						}
					} catch (NoSuchMethodException | SecurityException e) {
						e.printStackTrace();
					}
				} else {
					for (Method m : result.getClass().getMethods()) {
						if (command.equals(m.toString())) {
							try {
								m.invoke(result.getClass(), Object.class);
							} catch (IllegalAccessException | IllegalArgumentException | InvocationTargetException e) {
								e.printStackTrace();
							}
						}
					}
				}
			}

		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
