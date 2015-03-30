package ist.meic.pa;

import javassist.CannotCompileException;
import javassist.CtClass;
import javassist.CtMethod;
import javassist.expr.ConstructorCall;
import javassist.expr.ExprEditor;

public class ExtendedTranslator extends MyTranslator {
	
	@Override
	public void instrumentClass(CtClass ctClass) {
		super.instrumentClass(ctClass);
		
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
			}
		} catch (Exception e) {
			System.err.println("Error while instrumenting class " + ctClass.getName());
		}
	}
}
