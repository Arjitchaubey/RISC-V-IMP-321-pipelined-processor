Generation of clock, reset and output_en signals as expected by the testbench

![image](https://github.com/user-attachments/assets/679dad36-d86b-4192-bd2f-b715145fa5be)

Simulation results according the designed testbench

![image](https://github.com/user-attachments/assets/559a6be7-bedf-4680-903a-54f75ea8d98c)

The simulation log shows the following features as soon as the output_en signal is 1
  
    - PC increament by 4 
    
    - Instructions being fetched and decoded 
    
    - ALU results show the values 5, 10, 15 at the current cycles

    - Store and load operations occur at right times

    - Write back data matches the expected register values 

    - The remaining registers filled with xxxxxxxx (NOP) values as expected

![image](https://github.com/user-attachments/assets/c29971dd-4934-4b44-99bf-b179f3cecb18)

The final value of the registers in the simulation aligns with the expected results. Hence the simulation results are verified.
