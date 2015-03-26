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

	private void instrumentClass(CtClass ctClass) throws Throwable {

		//ADDED DIANA
//		//instrument constructor calls 
//		for(CtConstructor constructor : ctClass.getDeclaredConstructors()){
//			constructor.instrument(new ExprEditor() {
//				public void edit(ConstructorCall c) throws CannotCompileException {
//					final String templateConstructorCall;
//					templateConstructorCall = "ist.meic.pa.Command.exceptionCatcherConstructor(\"%s\", $args, $0);";
//					c.replace(String.format(templateConstructorCall, c.getMethodName()));
//				}
//			
//			});
//		}
		
		//instrument method calls, one case for void and another for the other types
		for (CtMethod method : ctClass.getDeclaredMethods()) {
			if (method.getReturnType().equals("void")) {
				method.instrument(new ExprEditor() {
					public void edit(MethodCall m) throws CannotCompileException {
						final String templateMethodCall;
						templateMethodCall = "ist.meic.pa.Command.exceptionCatcher(\"%s\", $args, $0);";
						m.replace(String.format(templateMethodCall, m.getMethodName()));
					}
				});
			} else {
				method.instrument(new ExprEditor() {
					public void edit(MethodCall m) throws CannotCompileException {
						final String templateMethodCall;
						templateMethodCall = "$_ = ($r) ist.meic.pa.Command.exceptionCatcherWithReturn(\"%s\", $args, $0);";
						m.replace(String.format(templateMethodCall, m.getMethodName()));
					}
				});
			}
		}
	}
}
