package test;

public class Example2 {
	
	public static int fact(int foo) {
		if (foo < 1) {
			throw new RuntimeException("foo < 1");
		}
		return foo*fact(foo-1);
	}
	
	public static int bar(String arg) {
		System.out.println("Converting " + arg + " to int.");
		int ret = Integer.parseInt(arg);
		System.out.println("Result " + ret);
		return ret;
	}
	
	public static void main(String[] args) {
		System.out.println("Started");
		for(String arg : args) {
			try {
				System.out.println(fact(bar(arg)));
			} catch(RuntimeException re) {
				System.out.println("Exception caught!");
			}
		}
		System.out.println("Finished");
	}

}
