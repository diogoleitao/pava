package lab03;

public class TestSimple {
    @Test public static void m1() { System.out.println("m1"); }
    @Test private static void m2() { System.out.println("m2"); }
    @Test private static void m3() { throw new RuntimeException("problem"); }
    public static void m4() { System.out.println("m4"); }
}
