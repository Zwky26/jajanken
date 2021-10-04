using System;

public class TestSprite
{
	/* TestHorizontalRotate
	 * receives user input for testing one call of HorizontalRotate
	 * on a sprite
	 *
	 * inputs:
	 *  Sprite start - the starting state of a sprite to test on
	 *  Sprite expected - the expected end state of the sprite
	 *  string[] args - it contains {"0", "int", "float", "char", "string"}
	 * outputs:
 	 *  no return value. Prints to the screen through function call
	 */
	public static uint TestHorizontalRotate(Sprite start, Sprite expected, string[] args)
	{
		int degrees;
		// make sure the degrees input is there
		if (args.Length < 16)	
		{
			Console.WriteLine("Too few arguments for "+
				"TestHorizontalRotate: " +args.Length);
			Console.WriteLine("Missing degrees input");
			Console.WriteLine("Test FAILED");
			return 0;
		}

		// convert degrees to an integer
		try
		{
			degrees = Int32.Parse(args[15]);
		}
		catch (FormatException e)
		{
			Console.WriteLine("Could not read degrees for "+
				"TestHorizontalRotate");
			Console.WriteLine(e.Message);
			return 0;
		}
		//Console.WriteLine("Start: "+start);
		// call the function
		start.HorizontalRotate(degrees);
		// see if it matches the expected result
		if (start.Equals(expected))
		{
			Console.WriteLine("HorizontalRotate("+degrees+
				"): Success!");
			return 1;
		}
		else
		{
			Console.WriteLine("HorizontalRotate("+degrees+
				"): FAIL!");
			Console.WriteLine("Expected: "+expected.ToString());
			Console.WriteLine("Actual: "+start.ToString());
			return 0;
		}
	}

	public static uint TestVerticalRotate(Sprite start, Sprite expected, string[] args)
	{
		int degrees;
		// make sure the degrees input is there
		if (args.Length < 16)	
		{
			Console.WriteLine("Too few arguments for "+
				"TestVerticalRotate: " +args.Length);
			Console.WriteLine("Missing degrees input");
			Console.WriteLine("Test FAILED");
			return 0;
		}

		// convert degrees to an integer
		try
		{
			degrees = Int32.Parse(args[15]);
		}
		catch (FormatException e)
		{
			Console.WriteLine("Could not read degrees for "+
				"TestVerticalRotate");
			Console.WriteLine(e.Message);
			return 0;
		}
		//Console.WriteLine("Start: "+start);
		// call the function
		start.VerticalRotate(degrees);
		// see if it matches the expected result
		if (start.Equals(expected))
		{
			Console.WriteLine("VerticalRotate("+degrees+
				"): Success!");
			return 1;
		}
		else
		{
			Console.WriteLine("VerticalRotate("+degrees+
				"): FAIL!");
			Console.WriteLine("Expected: "+expected.ToString());
			Console.WriteLine("Actual: "+start.ToString());
			return 0;
		}
	}

	public static uint TestMove(Sprite start, Sprite expected, string[] args)
	{
		int degrees;
		// make sure the degrees input is there
		if (args.Length < 16)	
		{
			Console.WriteLine("Too few arguments for "+
				"TestVerticalRotate: " +args.Length);
			Console.WriteLine("Missing degrees input");
			Console.WriteLine("Test FAILED");
			return 0;
		}

		// convert degrees to an integer
		try
		{
			degrees = Int32.Parse(args[15]);
		}
		catch (FormatException e)
		{
			Console.WriteLine("Could not read degrees for "+
				"TestVerticalRotate");
			Console.WriteLine(e.Message);
			return 0;
		}
		//Console.WriteLine("Start: "+start);
		// call the function
		start.VerticalRotate(degrees);
		// see if it matches the expected result
		if (start.Equals(expected))
		{
			Console.WriteLine("VerticalRotate("+degrees+
				"): Success!");
			return 1;
		}
		else
		{
			Console.WriteLine("VerticalRotate("+degrees+
				"): FAIL!");
			Console.WriteLine("Expected: "+expected.ToString());
			Console.WriteLine("Actual: "+start.ToString());
			return 0;
		}
	}

	public static uint TestDrinkSmallShieldPot(Sprite start, Sprite expected, string[] args)
	{
		int degrees;
		// make sure the degrees input is there
		if (args.Length < 16)	
		{
			Console.WriteLine("Too few arguments for "+
				"TestVerticalRotate: " +args.Length);
			Console.WriteLine("Missing degrees input");
			Console.WriteLine("Test FAILED");
			return 0;
		}

		// convert degrees to an integer
		try
		{
			degrees = Int32.Parse(args[15]);
		}
		catch (FormatException e)
		{
			Console.WriteLine("Could not read degrees for "+
				"TestVerticalRotate");
			Console.WriteLine(e.Message);
			return 0;
		}
		//Console.WriteLine("Start: "+start);
		// call the function
		start.VerticalRotate(degrees);
		// see if it matches the expected result
		if (start.Equals(expected))
		{
			Console.WriteLine("VerticalRotate("+degrees+
				"): Success!");
			return 1;
		}
		else
		{
			Console.WriteLine("VerticalRotate("+degrees+
				"): FAIL!");
			Console.WriteLine("Expected: "+expected.ToString());
			Console.WriteLine("Actual: "+start.ToString());
			return 0;
		}
	}

	public static uint TestDrinkLargeShieldPot(Sprite start, Sprite expected, string[] args)
	{
		int degrees;
		// make sure the degrees input is there
		if (args.Length < 16)	
		{
			Console.WriteLine("Too few arguments for "+
				"TestVerticalRotate: " +args.Length);
			Console.WriteLine("Missing degrees input");
			Console.WriteLine("Test FAILED");
			return 0;
		}

		// convert degrees to an integer
		try
		{
			degrees = Int32.Parse(args[15]);
		}
		catch (FormatException e)
		{
			Console.WriteLine("Could not read degrees for "+
				"TestVerticalRotate");
			Console.WriteLine(e.Message);
			return 0;
		}
		//Console.WriteLine("Start: "+start);
		// call the function
		start.VerticalRotate(degrees);
		// see if it matches the expected result
		if (start.Equals(expected))
		{
			Console.WriteLine("VerticalRotate("+degrees+
				"): Success!");
			return 1;
		}
		else
		{
			Console.WriteLine("VerticalRotate("+degrees+
				"): FAIL!");
			Console.WriteLine("Expected: "+expected.ToString());
			Console.WriteLine("Actual: "+start.ToString());
			return 0;
		}
	}

	public static uint TestApplyBandage(Sprite start, Sprite expected, string[] args)
	{
		int degrees;
		// make sure the degrees input is there
		if (args.Length < 16)	
		{
			Console.WriteLine("Too few arguments for "+
				"TestVerticalRotate: " +args.Length);
			Console.WriteLine("Missing degrees input");
			Console.WriteLine("Test FAILED");
			return 0;
		}

		// convert degrees to an integer
		try
		{
			degrees = Int32.Parse(args[15]);
		}
		catch (FormatException e)
		{
			Console.WriteLine("Could not read degrees for "+
				"TestVerticalRotate");
			Console.WriteLine(e.Message);
			return 0;
		}
		//Console.WriteLine("Start: "+start);
		// call the function
		start.VerticalRotate(degrees);
		// see if it matches the expected result
		if (start.Equals(expected))
		{
			Console.WriteLine("VerticalRotate("+degrees+
				"): Success!");
			return 1;
		}
		else
		{
			Console.WriteLine("VerticalRotate("+degrees+
				"): FAIL!");
			Console.WriteLine("Expected: "+expected.ToString());
			Console.WriteLine("Actual: "+start.ToString());
			return 0;
		}
	}

	public static uint TestUseMedKit(Sprite start, Sprite expected, string[] args)
	{
		int degrees;
		// make sure the degrees input is there
		if (args.Length < 16)	
		{
			Console.WriteLine("Too few arguments for "+
				"TestVerticalRotate: " +args.Length);
			Console.WriteLine("Missing degrees input");
			Console.WriteLine("Test FAILED");
			return 0;
		}

		// convert degrees to an integer
		try
		{
			degrees = Int32.Parse(args[15]);
		}
		catch (FormatException e)
		{
			Console.WriteLine("Could not read degrees for "+
				"TestVerticalRotate");
			Console.WriteLine(e.Message);
			return 0;
		}
		//Console.WriteLine("Start: "+start);
		// call the function
		start.VerticalRotate(degrees);
		// see if it matches the expected result
		if (start.Equals(expected))
		{
			Console.WriteLine("VerticalRotate("+degrees+
				"): Success!");
			return 1;
		}
		else
		{
			Console.WriteLine("VerticalRotate("+degrees+
				"): FAIL!");
			Console.WriteLine("Expected: "+expected.ToString());
			Console.WriteLine("Actual: "+start.ToString());
			return 0;
		}
	}

	public static uint TestWeaponDamage(Sprite start, Sprite expected, string[] args)
	{
		int degrees;
		// make sure the degrees input is there
		if (args.Length < 16)	
		{
			Console.WriteLine("Too few arguments for "+
				"TestVerticalRotate: " +args.Length);
			Console.WriteLine("Missing degrees input");
			Console.WriteLine("Test FAILED");
			return 0;
		}

		// convert degrees to an integer
		try
		{
			degrees = Int32.Parse(args[15]);
		}
		catch (FormatException e)
		{
			Console.WriteLine("Could not read degrees for "+
				"TestVerticalRotate");
			Console.WriteLine(e.Message);
			return 0;
		}
		//Console.WriteLine("Start: "+start);
		// call the function
		start.VerticalRotate(degrees);
		// see if it matches the expected result
		if (start.Equals(expected))
		{
			Console.WriteLine("VerticalRotate("+degrees+
				"): Success!");
			return 1;
		}
		else
		{
			Console.WriteLine("VerticalRotate("+degrees+
				"): FAIL!");
			Console.WriteLine("Expected: "+expected.ToString());
			Console.WriteLine("Actual: "+start.ToString());
			return 0;
		}
	}

	public static uint TestFallDamage(Sprite start, Sprite expected, string[] args)
	{
		int degrees;
		// make sure the degrees input is there
		if (args.Length < 16)	
		{
			Console.WriteLine("Too few arguments for "+
				"TestVerticalRotate: " +args.Length);
			Console.WriteLine("Missing degrees input");
			Console.WriteLine("Test FAILED");
			return 0;
		}

		// convert degrees to an integer
		try
		{
			degrees = Int32.Parse(args[15]);
		}
		catch (FormatException e)
		{
			Console.WriteLine("Could not read degrees for "+
				"TestVerticalRotate");
			Console.WriteLine(e.Message);
			return 0;
		}
		//Console.WriteLine("Start: "+start);
		// call the function
		start.VerticalRotate(degrees);
		// see if it matches the expected result
		if (start.Equals(expected))
		{
			Console.WriteLine("VerticalRotate("+degrees+
				"): Success!");
			return 1;
		}
		else
		{
			Console.WriteLine("VerticalRotate("+degrees+
				"): FAIL!");
			Console.WriteLine("Expected: "+expected.ToString());
			Console.WriteLine("Actual: "+start.ToString());
			return 0;
		}
	}

	public static uint TestRevive(Sprite start, Sprite expected, string[] args)
	{
		int degrees;
		// make sure the degrees input is there
		if (args.Length < 16)	
		{
			Console.WriteLine("Too few arguments for "+
				"TestVerticalRotate: " +args.Length);
			Console.WriteLine("Missing degrees input");
			Console.WriteLine("Test FAILED");
			return 0;
		}

		// convert degrees to an integer
		try
		{
			degrees = Int32.Parse(args[15]);
		}
		catch (FormatException e)
		{
			Console.WriteLine("Could not read degrees for "+
				"TestVerticalRotate");
			Console.WriteLine(e.Message);
			return 0;
		}
		//Console.WriteLine("Start: "+start);
		// call the function
		start.VerticalRotate(degrees);
		// see if it matches the expected result
		if (start.Equals(expected))
		{
			Console.WriteLine("VerticalRotate("+degrees+
				"): Success!");
			return 1;
		}
		else
		{
			Console.WriteLine("VerticalRotate("+degrees+
				"): FAIL!");
			Console.WriteLine("Expected: "+expected.ToString());
			Console.WriteLine("Actual: "+start.ToString());
			return 0;
		}
	}

	public static uint TestReboot(Sprite start, Sprite expected, string[] args)
	{
		int degrees;
		// make sure the degrees input is there
		if (args.Length < 16)	
		{
			Console.WriteLine("Too few arguments for "+
				"TestVerticalRotate: " +args.Length);
			Console.WriteLine("Missing degrees input");
			Console.WriteLine("Test FAILED");
			return 0;
		}

		// convert degrees to an integer
		try
		{
			degrees = Int32.Parse(args[15]);
		}
		catch (FormatException e)
		{
			Console.WriteLine("Could not read degrees for "+
				"TestVerticalRotate");
			Console.WriteLine(e.Message);
			return 0;
		}
		//Console.WriteLine("Start: "+start);
		// call the function
		start.VerticalRotate(degrees);
		// see if it matches the expected result
		if (start.Equals(expected))
		{
			Console.WriteLine("VerticalRotate("+degrees+
				"): Success!");
			return 1;
		}
		else
		{
			Console.WriteLine("VerticalRotate("+degrees+
				"): FAIL!");
			Console.WriteLine("Expected: "+expected.ToString());
			Console.WriteLine("Actual: "+start.ToString());
			return 0;
		}
	}

	public static void Main(string[] args)
	{
		uint testNumber = 2;
		Sprite testSprite = new Sprite();
		Sprite expectedSprite = new Sprite();
		// make sure there are enough arguments
		if (args.Length < 15)	
		{
			Console.WriteLine("Too few arguments: "+args.Length);
			Console.WriteLine("Usage: TestSprite.exe start_state "
				+"expected_end_state testNumber inputs " 
				+"expected_ret_val");
			System.Environment.Exit(0);
		}

		// get the starting state, ending state, and test number
		try
		{
			testSprite.SetState(
				int.Parse(args[0]),
				int.Parse(args[1]),
				int.Parse(args[2]),
				uint.Parse(args[3]),
				uint.Parse(args[4]),
				uint.Parse(args[5]),
				uint.Parse(args[6]));
			expectedSprite.SetState(
				int.Parse(args[7]),
				int.Parse(args[8]),
				int.Parse(args[9]),
				uint.Parse(args[10]),
				uint.Parse(args[11]),
				uint.Parse(args[12]),
				uint.Parse(args[13]));
			testNumber = uint.Parse(args[14]);
		}
		catch (FormatException e)
		{
			Console.WriteLine("Could not read testNumber");
			Console.WriteLine(e.Message);
			System.Environment.Exit(0);
		}

		// use the testnumber to choose a test function
		switch (testNumber)
		{
			case (0):
				TestHorizontalRotate(testSprite, 
					expectedSprite, args);
				break;
			case (1):
				TestVerticalRotate(testSprite,
				    expectedSprite, args);
				break;
			case (2):
				TestMove(testSprite,
				    expectedSprite, args);
				break;
			case (3):
				TestDrinkSmallShieldPot(testSprite,
				    expectedSprite, args);
				break;
			case (4):
				TestDrinkLargeShieldPot(testSprite,
				    expectedSprite, args);
				break;
			case (5):
				TestApplyBandage(testSprite,
				    expectedSprite, args);
				break;
			case (6):
				TestUseMedKit(testSprite,
				    expectedSprite, args);
				break;
			case (7):
				TestWeaponDamage(testSprite,
				    expectedSprite, args);
				break;
			case (8):
				TestFallDamage(testSprite,
				    expectedSprite, args);
				break;
			case (9):
				TestRevive(testSprite,
				    expectedSprite, args);
				break;
			case (10):
				TestReboot(testSprite,
				    expectedSprite, args);
				break;
		}
	}
}
