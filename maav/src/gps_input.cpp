/**
 * @file gps_input.cpp
 * @brief Offboard control example node, written with MAVROS version 0.19.x, PX4 Pro Flight
 * Stack and tested in Gazebo SITL
 */

#include <ros/ros.h>
#include <geometry_msgs/PoseStamped.h>
#include <geographic_msgs/GeoPoseStamped.h>
#include <mavros_msgs/CommandBool.h>
#include <mavros_msgs/SetMode.h>
#include <mavros_msgs/State.h>
#include <mavros_msgs/GlobalPositionTarget.h>
#include <sensor_msgs/NavSatFix.h>

using namespace std;

int main(int argc, char **argv)
{
    ros::init(argc, argv, "gps_input");
    ros::NodeHandle nh;

    ros::Publisher input_pub = nh.advertise<geographic_msgs::GeoPoseStamped>("input_gps", 1000);

    //the setpoint publishing rate MUST be faster than 2Hz
    ros::Rate rate(20.0);

    while (ros::ok())
    {
        // Read in lat, long, and alt.
        double latitude, longitude, altitude;

        cin >> latitude >> longitude >> altitude;

        geographic_msgs::GeoPoseStamped global_target;
        global_target.pose.position.latitude = latitude;
        global_target.pose.position.longitude = longitude;
        global_target.pose.position.altitude = altitude;

        // Send out our input GPS. For debugging.
        input_pub.publish(global_target);

        ros::spinOnce();
        rate.sleep();
    }

    return 0;
}
