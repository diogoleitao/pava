package ist.meic.pa.commands;

public class Return implements Command {

	@Override
	public void execute(String[] args) {
		Integer value = Integer.parseInt(args[1]);
	}

}
