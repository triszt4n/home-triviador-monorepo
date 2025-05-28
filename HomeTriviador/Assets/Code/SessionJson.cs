using System;
using System.Collections.Generic;
using JetBrains.Annotations;

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
    
    [Serializable]
    public class TipGameJson
    {
        public string id;
        public string question;
        public int tip;
    }
    
    [Serializable]
    public class IncomingTipJson
    {
        public string name;
        public int tip;
        public int ranking;
    }
    
    [Serializable]
    public class TipResultsJson
    {
        public IncomingTipJson[] incomingTips;
        public int winningTip;
    }
}