package ist.meic.pa;

import java.lang.reflect.Modifier;

import javassist.CannotCompileException;
import javassist.ClassPool;
import javassist.CtClass;
import javassist.CtConstructor;
import javassist.CtMethod;
import javassist.NotFoundException;
import javassist.Translator;
import javassist.expr.ConstructorCall;
import javassist.expr.ExprEditor;
import javassist.expr.MethodCall;

public class MyTranslator implements Translator {
	@SuppressWarnings("unused")
	private ClassPool pool;

	@Override
	public void start(ClassPool pool) throws NotFoundException, CannotCompileException {
	}

	@Override
	public void onLoad(ClassPool pool, String ctClass) throws NotFoundException, CannotCompileException {
		this.pool = pool;

		CtClass cc = pool.get(ctClass);
		cc.setModifiers(Modifier.PUBLIC);

		boolean javassist = ctClass.contains("javassist");
		boolean debugger = ctClass.contains("ist.meic.pa");

		if (!javassist && !debugger) {
			try {
				instrumentClass(cc);
			} catch (Throwable e) {
				e.printStackTrace();
			}
		}
	}

	private void instrumentClass(CtClass ctClass) {

		try {
			//instrument method calls, one case for void and another for the other types
			for (CtMethod method : ctClass.getDeclaredMethods()) {

				//instrument constructor calls inside each method
				method.instrument(new ExprEditor() {
					public void edit(ConstructorCall c) throws CannotCompileException {
						final String templateConstructorCall;
						templateConstructorCall = "ist.meic.pa.Command.exceptionCatcherConstructor(\"%s\", $args, $0);";
						c.replace(String.format(templateConstructorCall, c.getMethodName()));
					}

				});

				// instrument method calls inside each method
				method.instrument(new ExprEditor() {
					public void edit(MethodCall m) throws CannotCompileException {
						final String templateMethodCall;
						templateMethodCall = "$_ = ($r) ist.meic.pa.Command.exceptionCatcherWithReturn(\"%s\", $args, $0);";
						m.replace(String.format(templateMethodCall, m.getMethodName()));
					}
				});
			}

			for (CtConstructor constructor : ctClass.getDeclaredConstructors()) {
/*
				//instrument constructor calls inside each constructor
				constructor.instrument(new ExprEditor() {
					public void edit(ConstructorCall c) throws CannotCompileException {
						final String templateConstructorCall;
						templateConstructorCall = "ist.meic.pa.Command.exceptionCatcherConstructor(\"%s\", $args, $0);";
						c.replace(String.format(templateConstructorCall, c.getMethodName()));
					}
				});
*/

				//instrument method calls inside each constructor
				constructor.instrument(new ExprEditor() {
					public void edit(MethodCall m) throws CannotCompileException {
						final String templateMethodCall;
						templateMethodCall = "$_ = ($r) ist.meic.pa.Command.exceptionCatcherWithReturn(\"%s\", $args, $0);";
						m.replace(String.format(templateMethodCall, m.getMethodName()));
					}
				});
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}
	}
}
