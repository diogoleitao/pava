package ist.meic.pa.commands;

import java.util.ArrayList;

public class Info implements Command {

	@Override
	public void execute(String[] args) {
		
		ArrayList<String> fields = new ArrayList<String>();
		String output = "Called Object: " + new Object().toString() + "\n\t\t" + 
								"Fields: " + fields.toString() + "\n\t\t" + 
						"Call Stack:\n" + "";
	}
}
