public class TestSuperclass {
    protected String foo;

    public String method() {
        return "TestSuperclass#method";
    }

    public String myLongMethodName() {
        return "TestSuperclass#myLongMethodName";
    }

    public String myLongMethodNameWithABBRV() {
        return "TestSuperclass#myLongMethodNameWithABBRV";
    }

    public boolean isFooBar() {
        return true;
    }

    public String getFoo() {
        return this.foo;
    }

    public void setFoo(String foo) {
        this.foo = foo;
    }

    public String testInterface(TestInterface ti) {
        return ti.method() + ti.myLongMethodNameWithABBRV();
    }

    protected String protectedMethod() {
        return "TestSuperclass#protectedMethod";
    }

    public String testProtectedMethod() {
        return protectedMethod();
    }
}
