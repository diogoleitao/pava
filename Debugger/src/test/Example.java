package test;

class A {
	int a = 1;

	public double foo(B b) {
		System.out.println("Inside A.foo");
		if (a == 1) {
			return b.bar(0);
		} else {
			return b.baz(null);
		}
	}
}

class B {
	double b = 3.14;

	public double bar(int x) {
		System.out.println("Inside B.bar");
		return (1 / x);
	}

	public double baz(Object x) {
		System.out.println("Inside B.baz");
		System.out.println(x.toString());
		return b;
	}
}

public class Example {

	public static void main(String[] args) {
		System.out.println(new A().foo(new B()));
	}
}
