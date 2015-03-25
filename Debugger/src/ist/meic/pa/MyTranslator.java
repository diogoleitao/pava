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
			e.printStackTrace();
		}
	}

	private void instrumentClass(CtClass ctClass) throws NotFoundException {
		// SAVE STATE FOR COMMAND'S INFO METHOD
		for (CtMethod method : ctClass.getDeclaredMethods()) {
			try {
				if (!method.getReturnType().getName().equals("void"))
					method.addCatch("{ return (" + method.getReturnType().getName() + ") 0; }", pool.getCtClass("java.lang.Exception"));
			} catch (CannotCompileException e) {
				e.printStackTrace();
			}
		}
	}
}
