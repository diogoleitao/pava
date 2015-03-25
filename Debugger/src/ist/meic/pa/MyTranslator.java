package ist.meic.pa;

import java.lang.reflect.Modifier;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;

import javassist.CannotCompileException;
import javassist.ClassPool;
import javassist.CtClass;
import javassist.CtField;
import javassist.CtMethod;
import javassist.CtNewMethod;
import javassist.NotFoundException;
import javassist.Translator;
import javassist.expr.ExprEditor;
import javassist.expr.FieldAccess;

public class MyTranslator implements Translator {
	private ClassPool pool;
	private HashMap<String, ArrayList<CtField>> classFields = new HashMap<String, ArrayList<CtField>>();

	@Override
	public void start(ClassPool pool) throws NotFoundException,
	CannotCompileException {
	}

	@Override
	public void onLoad(ClassPool pool, String ctClass) throws NotFoundException, CannotCompileException {
		this.pool = pool;
		CtClass cc = pool.get(ctClass);
		cc.setModifiers(Modifier.PUBLIC);

		try {
			instrumentClass(cc);
		} catch (Throwable e) {
			System.out.println("Class cannot be instrumented");
		}
	}

	private void instrumentClass(CtClass ctClass) throws NotFoundException, CannotCompileException {
		CtField f = new CtField(CtClass.intType, "state", ctClass);
		f.setModifiers(8);
		ctClass.addField(f);

		CtMethod m = CtNewMethod.make("public void printState() { System.out.println(state); }", ctClass);
		ctClass.addMethod(m);

		classFields.put(ctClass.getName(), new ArrayList<CtField>(Arrays.asList(ctClass.getDeclaredFields())));

		for (CtMethod method : ctClass.getDeclaredMethods()) {
			if (method.getName().equals("main")) {
				try {
					method.addCatch("{ System.out.println($e); ist.meic.pa.Command.startCLI(); return; }", pool.getCtClass("java.lang.Exception"));
				} catch (CannotCompileException e) {
					e.printStackTrace();
				}
			} else {
				try {
					final String template = "ist.meic.pa.History.storePrevious($0, \"%s\",\"%s\", ($w)$0.%s);";
					method.instrument(new ExprEditor() {
						public void edit(FieldAccess fa) throws CannotCompileException {
							if (fa.isWriter()) {
								String name = fa.getFieldName();
								fa.replace(String.format(template, fa.getClassName(), name, name, name));
							}
						}
					});
//					method.insertBefore("ist.meic.pa.Command.stateC = ist.meic.pa.History.currentState();");
					method.insertBefore("System.out.println(ist.meic.pa.History.undoTrail.toString());");
					method.addCatch("{ throw $e; }", pool.getCtClass("java.lang.Exception"));
				} catch (CannotCompileException e) {
					e.printStackTrace();
				}
			}
		}
	}
}
