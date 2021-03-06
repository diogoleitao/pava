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

/**
 * The ExtendedTranslator classes implements the Translator
 * interface and overrides the onLoad method so that
 * it is possible for us to instrument the classes
 * as we want to; it also instruments the constructors
 */
public class ExtendedTranslator implements Translator {

	@Override
	public void start(ClassPool pool) throws NotFoundException, CannotCompileException {
	}

	@Override
	public void onLoad(ClassPool pool, String ctClass) throws NotFoundException {
		CtClass cc = pool.get(ctClass);
		cc.setModifiers(Modifier.PUBLIC);

		boolean javassist = ctClass.contains("javassist");
		boolean debugger = ctClass.contains("ist.meic.pa");

		if (!javassist && !debugger) {
			try {
				instrumentClass(cc);
			} catch (Throwable e) {
				System.err.println("Error while instrumenting class " + ctClass);
			}
		}
	}

	private void instrumentClass(CtClass ctClass) throws CannotCompileException {
		//instrument class methods
		for (CtMethod method : ctClass.getDeclaredMethods()) {
			// instrument method calls inside each method
			method.instrument(new ExprEditor() {
				public void edit(MethodCall methodCall) throws CannotCompileException {
					final String templateMethodCall;
					templateMethodCall = "$_ = ($r) ist.meic.pa.Command.exceptionCatcherWithReturn(\"%s\", $args, $0);";
					methodCall.replace(String.format(templateMethodCall, methodCall.getMethodName()));
				}
			});
			// instrument constructor calls inside each method
			method.instrument(new ExprEditor() {
				public void edit(ConstructorCall c) throws CannotCompileException {
					final String templateConstructorCall;
					templateConstructorCall = "ist.meic.pa.Command.exceptionCatcherConstructor(\"%s\", $args, $0);";
					c.replace(String.format(templateConstructorCall, c.getMethodName()));
				}

			});
		}

		//instrument class constructors
		for (CtConstructor constructor : ctClass.getDeclaredConstructors()) {
			//instrument method calls inside each constructor
			constructor.instrument(new ExprEditor() {
				public void edit(MethodCall methodCall) throws CannotCompileException {
					final String templateMethodCall;
					templateMethodCall = "$_ = ($r) ist.meic.pa.Command.exceptionCatcherWithReturn(\"%s\", $args, $0);";
					methodCall.replace(String.format(templateMethodCall, methodCall.getMethodName()));
				}
			});
		}
	}
}
