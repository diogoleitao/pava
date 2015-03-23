package ist.meic.pa.commands;

public class Return implements ICommand {

	@Override
	public void execute(String[] args) {
		Integer value = Integer.parseInt(args[1]);
	}

}
