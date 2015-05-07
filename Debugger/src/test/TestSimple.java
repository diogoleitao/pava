package test;

public class TestSimple {

	public static int a = 1;

	public static void foo() {
		throw new RuntimeException("bazinga");
	}

	public static void main(String[] args) {
		try {
			foo();
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}
	}
}