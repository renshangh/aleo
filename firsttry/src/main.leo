// The 'firsttry' program.
program firsttryonlearningclass1.aleo {
    transition main(public a: u32, b: u32) -> u32 {
        let c: u32 = a + b;
        // write a function to pick the maximum of 5 numbers
        return c;
    }

    transition max(numbers: [u8; 10]) -> u8 {
        // Initialize max with the first element
        let maxN: u8 = numbers[0u8];
        
        // Iterate through the array from index 1 to 9
        for i:u8 in 1u8..10u8 {
            if numbers[i] > maxN {
                maxN = numbers[i];
            }
        }
        
        // Return the maximum value
        return maxN; // Fixed the return value to maxN
    }
}