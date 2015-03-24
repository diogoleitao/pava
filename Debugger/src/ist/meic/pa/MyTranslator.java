package ist.meic.pa;

import java.lang.reflect.Modifier;

import javassist.CannotCompileException;
import javassist.ClassPool;
import javassist.CtClass;
import javassist.CtMethod;
import javassist.NotFoundException;
import javassist.Translator;

public class MyTranslator implements Translator {
	private ClassPool myPool;

	@Override
	public void onLoad(ClassPool pool, String ctClass)
			throws NotFoundException, CannotCompileException {
		myPool = pool;
		CtClass cc = pool.get(ctClass);
		cc.setModifiers(Modifier.PUBLIC);

		try {
			instrumentClass(cc);
		} catch (Throwable e) {
			e.printStackTrace();
		}
	}

	@Override
	public void start(ClassPool arg0) throws NotFoundException,
			CannotCompileException {
	}

	private void instrumentClass(CtClass ctClass) throws NotFoundException {
		// SAVE STATE FOR COMMAND'S INFO METHOD
		for (CtMethod method : ctClass.getDeclaredMethods()) {
			try {
				// method.insertBefore("int state0 = History.currentState");
				method.addCatch("{ System.out.println($e); throw $e; }", myPool.getCtClass("java.lang.Exception"));
			} catch (CannotCompileException e) {
				e.printStackTrace();
			}
		}
	}
}
