/** Struct necessary for update library variables*/

struct update_variables{
  int update_available;   /**< Flag that indicates if an update notification has been received */
  int update_in_progress;  /**< Flag that indicates if the running process is a dynamic update */
  int updated_from;       /**< Identifier of the update point where the previous version stopped its execution */
  int old_version_pid;   /**< Pid of the running process to be replaced */
};

/**
  *Here developers add structs of variables necessary for the dynamic update.
  *Struct for the previous version and for the new version must be included.

*/

struct container{
  string name<50>;
  float num_executions;
};

struct container_2{
  string name<50>;
  int  num_executions;
};
