using System;
using System.Collections.Generic;

namespace Code
{
    [Serializable]
    public class UserJson
    {
        public string id;
        public string name;
        public int points;
        public int[] conqueredPlaces;
    }
    
    [Serializable]
    public class SessionJson
    {
        public string id;
        public string state;
        public int phase;
        public UserJson[] players;
    }
}