package ist.meic.pa;

import java.lang.reflect.Modifier;

import javassist.CannotCompileException;
import javassist.ClassPool;
import javassist.CtClass;
import javassist.CtField;
import javassist.CtMethod;
import javassist.NotFoundException;
import javassist.Translator;
import javassist.expr.ExprEditor;
import javassist.expr.MethodCall;

public class MyTranslator implements Translator {
	private ClassPool pool;

	@Override
	public void start(ClassPool pool) throws NotFoundException, CannotCompileException {
	}

	@Override
	public void onLoad(ClassPool pool, String ctClass) throws NotFoundException, CannotCompileException {
		this.pool = pool;

		CtClass cc = pool.get(ctClass);
		cc.setModifiers(Modifier.PUBLIC);
		
		boolean javassist = cc.getClass().getName().contains("javassist");
		boolean debugger = cc.getClass().getName().contains("ist.meic.pa");

		if (!(javassist || debugger)) {
			try {
				instrumentClass(cc);
			} catch (Throwable e) {
				e.printStackTrace();
			}
		}
	}

	private void instrumentClass(CtClass ctClass) throws Throwable {
		CtField f = new CtField(CtClass.intType, "state", ctClass);
		f.setModifiers(8);
		ctClass.addField(f);

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
		/*
		for (CtConstructor constructor : ctClass.getConstructors()) {
			constructor.instrument(new ExprEditor() {
				public void edit(MethodCall m) throws CannotCompileException {
					final String templateMethodCall;
					templateMethodCall = "ist.meic.pa.Command.exceptionCatcher(\"%s\", $args, $0);";
					m.replace(String.format(templateMethodCall, m.getMethodName()));
				}
			});
		}*/
	}
}
