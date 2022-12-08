Composing with New Musical Instruments 
Aalto University, 2022


# [lucidgloves](https://github.com/LucidVR/lucidgloves) wi-fi interpreter & sound controller
with [SuperCollider](https://github.com/supercollider/supercollider) and [Bela](https://bela.io).

  The main idea of this project is to sonfiy aspects of the 2.4 GHz frequency spectrum and allow the wearer
to engage with the generally invisible wave band on a sonic and tactile level. The sonic control is implemented
by sending the potentiometer data from each finger on the glove into SuperCollider. Because a potentiometer is 
such a common use case in musical applications, it easily integrates into conceivably any piece of code or patch
with a few knobs! The force-feedback provided by the servo motors creates the impression of holding an object of 
varying solidity.

<img src="https://github.com/swirkes/lucidgloves_Wi-Fi_collider/blob/main/pics/frequency_graph.png" alt="freq_graph" width="350"/> <img src="https://github.com/swirkes/lucidgloves_Wi-Fi_collider/blob/main/pics/topology1.png" alt="topology" width="350"/>

  For the purposes of the the 6-week intensive workshop (which was practically 3 weeks of work on this project), 
I was able to fabricate one glove with 5 spring-loaded potentiometers that track the movement of each finger.
Additionally, I created a sample code in SuperCollider that uses the glove as an interface to control the parameters
of three different synthesizers.

  I am really satisfied with quality and aesthetic of the build so far. The spring mechanisms do not function fluidly
or very uniformly. When I played music with it, this apparent defect, for me became a very joyful experience that I 
was really coaxing the bits out of the digital instrument. I used a cheap work glove from Biltema along with the springs
and metal strings from retractable badge holders. It felt like a salvage project (although I was compelled to buy a lot
of new parts), so being able to feel that aspect so directly while performing with it has made me want to continue 
developing the idea.

## 3D Printing
 I began printing the components for the project right away. This involved a lot of learning as I needed to get access 
to the 3D print lab and learn the system at Aalto for the first time. I also needed to do many test prints to get the 
all the parameters right.

<img src="https://github.com/swirkes/lucidgloves_Wi-Fi_collider/blob/main/pics/glove_lab_no_pot.JPG" alt="glove_lab_no_pot" width="250"/> <img src="https://github.com/swirkes/lucidgloves_Wi-Fi_collider/blob/main/pics/spring_loaded_pot.JPG" alt="spring_pot" width="250"/>

  In the end, I printed about 4 days a week for 2 weeks. I tried not to print multiples until I had a good idea of the 
quality so I didn't have to throw away a lot of scraps.

## Assembly
  The biggest obstacle to progress in this project was waiting for the
components. I built out one spring loaded pot and tested some of the 
[firmware code](https://github.com/swirkes/lucidgloves_Wi-Fi_collider/tree/main/sketches/servoHapticsTestArduinoUNO) on an Arduino. In retrospect, my time would have been better spent with SuperCollider.

<img src="https://github.com/swirkes/lucidgloves_Wi-Fi_collider/blob/main/pics/velcro_strap.JPG" alt="velcro" width="350"/> <img src="https://github.com/swirkes/lucidgloves_Wi-Fi_collider/blob/main/pics/wrapping_rings.JPG" alt="wrapping_rings" width="350"/>

The wiring and threading of the glove were labor intensive. With repetetive tasks, you usually improve over time. However, since I was only making 5 of
everything, I was done as soon as I started to get proficient. In any case, once I had all the necessary parts, the build was pretty straight-forward.

I veered away from the lucidgloves project pretty heavily at this point when I began wiring the glove. Instead of using the ESP32, I decided to run the 
output straight into bela's analog inputs. This allowed me to make music directly when time was of the essence. 

<img src="https://github.com/swirkes/lucidgloves_Wi-Fi_collider/blob/main/pics/close_up_bela.JPG" alt="bela" width="350"/> <img src="https://github.com/swirkes/lucidgloves_Wi-Fi_collider/blob/main/pics/working_from_home.JPG" alt="work_from_home" width="350"/>




 
