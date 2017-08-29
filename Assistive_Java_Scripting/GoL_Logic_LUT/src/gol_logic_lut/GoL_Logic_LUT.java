package gol_logic_lut;

//Any live cell with fewer than two live neighbours dies, as if caused by under-population
//Any live cell with two or three live neighbours lives on to the next generation
//Any live cell with more than three live neighbours dies, as if by over-population
//Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction
//NNN
//NCN
//NNN
//N - Neighbor
//C - Cell
//Loading style: CNNNNNNNN [golString]

public class GoL_Logic_LUT 
{
    //Creates the LUT for the GoL_Logic VHDL file:
    public static void main(String[] args)
    {
        System.out.println("case Current_State is");
        for(int n = 0; n < 512; n++)
        {
            //Current_State|Updated_State
            if(interpretGoLString(integerToBinaryString(n, 9)) == 1)
            {
                System.out.println("when \"" + integerToBinaryString(n, 9) + "\" => Updated_State <= '1';");
            }
        }
        System.out.println("when others => Updated_State <= '0';");
        System.out.println("end case;");
    }
    
    //Converts integer to binary representation in a String of '1's and '0's:
    public static String integerToBinaryString(int value, int bits)
    {
        String output = "";
        for(int n = (int)Math.pow(2, bits - 1); n > 0; n /= 2)
        {
            if(value >= n)
            {
                value -= n;
                output += "1";
            }
            else
            {
                output += "0";
            }
        }
        return output;
    }
    
    //Returns the amount of living neighbors in a golString:
    public static int golLivingNeighbors(String input)
    {
        int output = 0;
        for(int i = 1; i < input.length(); i++)
        {
            if(input.charAt(i) == '1')
            {
                output += 1;
            }
        }
        return output;
    }
    
    //Returns an integer signifying whether the cell will live(1) or die(0):
    public static int interpretGoLString(String input)
    {
        if(input.charAt(0) == '1')
        {
            if(golLivingNeighbors(input) < 2)
            {
                return 0;
            }
            else if(golLivingNeighbors(input) > 3)
            {
                return 0;
            }
            else
            {
                return 1;
            }
        }
        else
        {
            if(golLivingNeighbors(input) == 3)
            {
                return 1;
            }
            else
            {
                return 0;
            }
        }
    }
}