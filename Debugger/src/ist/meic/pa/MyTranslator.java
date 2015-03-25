package ist.meic.pa;

import java.lang.reflect.Modifier;

import javassist.CannotCompileException;
import javassist.ClassPool;
import javassist.CtClass;
import javassist.CtMethod;
import javassist.NotFoundException;
import javassist.Translator;

public class MyTranslator implements Translator {
	//private HashMap<Object, ObjectFieldValue> ; 
	private ClassPool pool;
	
	@Override
	public void start(ClassPool pool) throws NotFoundException, CannotCompileException {}

	@Override
	public void onLoad(ClassPool pool, String ctClass)
			throws NotFoundException, CannotCompileException {
		this.pool = pool;
		CtClass cc = pool.get(ctClass);
		cc.setModifiers(Modifier.PUBLIC);

		try {
			instrumentClass(cc);
		} catch (Throwable e) {
			System.out.println(e);
		}
	}

	private void instrumentClass(CtClass ctClass) throws NotFoundException {
		for (CtMethod method : ctClass.getDeclaredMethods()) {
			if (method.getName().equals("main")){
				try {
					method.addCatch("{ System.out.println($e); return; }", pool.getCtClass("java.lang.Exception"));
				} catch (CannotCompileException e) {
					e.printStackTrace();
				}
				
			} else {
				try {
					if (!method.getReturnType().getName().equals("void"))
						method.addCatch("{ throw $e; }", pool.getCtClass("java.lang.Exception"));
				} catch (CannotCompileException e) {
					e.printStackTrace();
				}
			}
		}
	}
}
