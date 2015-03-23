package ist.meic.pa.commands;

public class Set implements ICommand {

	@Override
	public void execute(String[] args) {
		String field = args[1];
		Integer value = Integer.parseInt(args[2]);

	}
}
