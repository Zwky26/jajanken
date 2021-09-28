using System;

public class Sprite {
 	private int XCoor;
 	private int YCoor;
 	private int ZCoor;
	private uint Horiz;
	private uint Vert;
 	private uint Health;
	private uint Shield;

	/* Default constructor
	 * set all values to 0
	 */
 	public Sprite()
 	{
		XCoor = 0;
		YCoor = 0;
		ZCoor = 0;
		Horiz = 0;
		Vert = 0;
		Health = 0;
		Shield = 0;
	}

	/* SetState
  	 * receives inputs for all instance variables.
	 * sets all of the instance variables to inputs
	 */
	public void SetState(int x, int y, int z, 
		uint horiz, uint vert, uint h, uint s)
	{
		XCoor = x;
		YCoor = y;
		ZCoor = z;
		Horiz = horiz;
		Vert = vert;
		Health = h;
		Shield = s;
	}

	/* Equals
	 * Compares an input object to the current object
	 * If the input object is non-null, a Sprite, and all 
	 * fields match, return true, otherwise return false
	 */
	public override bool Equals(Object obj)
	{
		//Check for null and compare run-time types.
      		if ((obj == null) || ! this.GetType().Equals(obj.GetType()))
      		{
         		return false;
      		}
      		else 
		{
         		Sprite s = (Sprite) obj;
			return ((XCoor == s.XCoor) &&
				(YCoor == s.YCoor) &&
				(ZCoor == s.ZCoor) &&
				(Horiz == s.Horiz) &&
				(Vert == s.Vert) &&
				(Health == s.Health) &&
				(Shield == s.Shield));
      		}
	}

	/* GetHashCode
	 * This produces a non-unique but at least somewhat unique
	 * number based on a sprite's state.
	 */
	public override int GetHashCode()
	{
		return (int)(XCoor ^ (YCoor << 8) ^ (ZCoor << 16) ^
			Horiz ^ (Vert << 9) ^ 
			(Health << 18) ^ (Shield << 25));
	}

	/* ToString
	 * Creates a string that can be used to print out the 
	 * Sprite's state in human-readable form
	 */
	public override String ToString()
	{
		return String.Format(
			"Sprite: loc({0},{1},{2}),rot({3},{4}),hs({5},{6})",
			XCoor, YCoor, ZCoor, Horiz, Vert, Health, Shield);
	}

	/* HorizontalRotate
	 * rotates along the horizontal axis.
	 * inputs:
	 *   int degrees - amount to rotate
	 * outputs:
	 *   modifies instance variable Horiz
	 */
	public void HorizontalRotate(int degrees)
	{
		new = Horiz + degrees;
		if (new < 0):
			Horiz = abs(new);
		else if (new > 360):
			Horiz = new - 360;
		else:
			Horiz = new;
		return;
	}

	/* VerticalRotate
	 * rotates along the vertical axis.
	 * inputs:
	 *   int degrees - amount to rotate
	 * outputs:
	 *   modifies instance variable Vert
	 */
	public void VerticalRotate(int degrees)
	{
		new = Vert + degrees;
		if (new < 0):
			Vert = abs(new);
		else if (new > 360):
			Vert = new - 360;
		else:
			Vert = new;
		return;
	}



	/* Move
 	 * Changes the location to move Sprite in direction it is pointing
	 * along the horizontal axis.
	 * inputs:
	 *   int steps
	 * outputs:
	 *   modifies instance variables XCoor, YCoor as appropriate
	 */
	public void Move(int steps)
	{
		Console.WriteLine("Not Yet Implemented");
	}

	/* DrinkSmallShieldPot
	 * Increases Shield by 25, up to a max of 50
	 * outputs:
	 *  Modifies instance variable Shield
	 *  returns 1 if made modification, 0 if not
 	 */
	public uint DrinkSmallShieldPot()
	{
		newShield = min(50, Shield + 25);
		if(newShield == Shield):
			return 0;
		else:
			return 1;
	}

	/* DrinkLargeShieldPot
	 * Increases Shield by 50, up to a max of 100
	 * outputs:
	 *  Modifies instance variable Shield
	 *  returns 1 if made modification, 0 if not
 	 */
	public uint DrinkLargeShieldPot()
	{
		CnewShield = min(100, Shield + 50);
		if(newShield == Shield):
			return 0;
		else:
			return 1;
	}

	/* ApplyBandage
	 * Increases Health by 15, up to a max of 75
	 * outputs:
	 *  Modifies instance variable Health
	 *  returns 1 if made modification, 0 if not
 	 */
	public uint ApplyBandage()
	{
		Console.WriteLine("Not Yet Implemented");
		return 0;
	}

	/* UseMedKit
	 * Sets Health to 100
	 * outputs:
	 *  Modifies instance variable Health
	 *  returns 1 if made modification, 0 if not
 	 */
	public uint UseMedKit()
	{
		Console.WriteLine("Not Yet Implemented");
		return 0;
	}

	/* WeaponsDamage
	 * Decrements Shield by damage, down to a min of 0
	 * If still damage left, decrements Health by leftover damage,
	 * down to a min of 0
	 * outputs:
	 *  Modifies instance variables Shield, Health
	 *  returns 1 if resulting Health > 0, 0 if not
 	 */
	public uint WeaponDamage(uint damage)
	{
		Console.WriteLine("Not Yet Implemented");
		return 0;
	}

	/* WeaponsDamage
	 * Decrements Health by damage, down to a min of 0
	 * outputs:
	 *  Modifies instance variable Health
	 *  returns 1 if resulting Health > 0, 0 if not
 	 */
	public uint FallDamage(uint damage)
	{
		Console.WriteLine("Not Yet Implemented");
		return 0;
	}

	public uint Revive(uint damage)
	{
		Console.WriteLine("Not Yet Implemented");
		return 0;
	}

	public uint Reboot(uint damage)
	{
		Console.WriteLine("Not Yet Implemented");
		return 0;
	}

}