package lab03;

public class TestWithInheritance extends TestWithSetup {
    @Setup("s4") protected static void s5() { System.out.println("s4"); }

    @Test("*") public static void m10() { System.out.println("m10"); }
    @Test("s2") public void m11() { System.out.println("m11"); }
    @Test("s1") public static void m12() { System.out.println("m12"); }
    public static void m13() { System.out.println("m13"); }
    @Test({"s1", "s4"}) public static void m14() { System.out.println("m14"); }
}
