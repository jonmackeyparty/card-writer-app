Using the Cardwriter app -- 

1. Convert the written note images from each directory using the CardWriter.convert_images_from_directory function -- will need to customize the save_path var to match whatever housing unit the cards are addressed to.
2.  Use the CardWriter.card_printer function to print X number of card art covers -- these will be fed back into the printer for step 3.
3.  Use CardWriter.letter_printer to print on the images on card stock from step 1 using the feed tray.  Each iteration hs a 5 second sleep so be diligent lol.

There are additional methods for cleaning up filenames and rotating images by dimension if necessary.
