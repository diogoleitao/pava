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
import javassist.expr.MethodCall;

public class MyTranslator implements Translator {
	private ClassPool pool;
	private HashMap<String, ArrayList<CtField>> classFields = new HashMap<String, ArrayList<CtField>>();

	@Override
	public void start(ClassPool pool) throws NotFoundException,
			CannotCompileException {
	}

	@Override
	public void onLoad(ClassPool pool, String ctClass)
			throws NotFoundException, CannotCompileException {
		this.pool = pool;
		CtClass cc = pool.get(ctClass);
		cc.setModifiers(Modifier.PUBLIC);

		try {
			instrumentClass(cc);
		} catch (Throwable e) {
			e.printStackTrace();
//			System.out.println("Class cannot be instrumented");
//			System.out.println(e.getMessage()); 
		}
	}

	private void instrumentClass(CtClass ctClass) throws NotFoundException,
			CannotCompileException {
		
	
		CtField f = new CtField(CtClass.intType, "state", ctClass);
		f.setModifiers(8);
		ctClass.addField(f);
		
		//Pass fields to Command Class 
		Command.setCtFields(new ArrayList<CtField>(Arrays.asList(ctClass.getDeclaredFields())));
		
		

		CtMethod m = CtNewMethod.make(
				"public void printState() { System.out.println(state); }",
				ctClass);
		ctClass.addMethod(m);

		classFields.put(
				ctClass.getName(),
				new ArrayList<CtField>(Arrays.asList(ctClass
						.getDeclaredFields())));

		for (CtMethod method : ctClass.getDeclaredMethods()) {

			if (method.getName().equals("main")) {
				method.instrument(new ExprEditor() {
					public void edit(MethodCall m)
							throws CannotCompileException {
						final String templateMethodCall;
						if (m.getSignature().contains("void")) {
							templateMethodCall = "try {"
									+ 				"$proceed($$);"
									+ 			 "} catch (Exception e) {"
									+ 					"System.out.println(e);"
									+ 					"ist.meic.pa.Command.startCLI(e.getStackTrace()[0].getClassName());"
									+ 					"return;"
									+			 "}";
						} else
							templateMethodCall = "try {"
									+ 				"$_ = $proceed($$);"
									+ 			 "} catch (Exception e) {"
									+ 					"System.out.println(e);"
									+ 					"ist.meic.pa.Command.startCLI(e.getStackTrace()[0].getClassName());"
									+ 					"return;"
									+			 "}";
						m.replace(templateMethodCall);
					}
				});

			} else {
				method.instrument(new ExprEditor() {
					public void edit(MethodCall m)
							throws CannotCompileException {
						final String templateMethodCall;
						if (m.getSignature().contains("void")) {
							templateMethodCall = "try {$proceed($$);} catch (Exception e) { throw e;}";
						} else
							templateMethodCall = "try {$_ = $proceed($$);} catch (Exception e) {throw e;}";
						m.replace(templateMethodCall);
					}
				});
				try {
					final String template = "ist.meic.pa.History.storePrevious($0, \"%s\",\"%s\", ($w)$0.%s);";
					method.instrument(new ExprEditor() {
						public void edit(FieldAccess fa)
								throws CannotCompileException {
							if (fa.isWriter()) {
								String name = fa.getFieldName();
								fa.replace(String.format(template,
										fa.getClassName(), name, name, name));
							}
						}
					});
				} catch (CannotCompileException e) {
					e.printStackTrace();
				}
			}
		}
	}
}
