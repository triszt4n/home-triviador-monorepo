using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using TMPro;
using UnityEngine;
using UnityEngine.Networking;
using UnityEngine.UI;

namespace Code
{
    public class GameHandler : MonoBehaviour
    {
        [SerializeField] private Color startingColor = Color.yellowNice; // The color to change to

        private List<Image> _countyImages;
    
        public TMP_Text player1Name;
        public TMP_Text player1Points;
        public TMP_Text player2Name;
        public TMP_Text player2Points;
        public TMP_Text player3Name;
        public TMP_Text player3Points;
        public Button syncButton;
        public TMP_Text messageText;
        public TMP_Text timerText;

        private void Awake()
        {
            player1Name.text = "Waiting...";
            player1Points.text = "0";
            player2Name.text = "Waiting...";
            player2Points.text = "0";
            player3Name.text = "Waiting...";
            player3Points.text = "0";
            messageText.text = "Waiting for players to join...";
            timerText.text = "00:00";
            timerText.GetComponentInChildren<Image>().transform.localScale = new Vector3(0, 0, 0);
        }

        // Start is called once before the first execution of Update after the MonoBehaviour is created
        void Start()
        {
            var images = gameObject.GetComponentsInChildren<Image>();
            _countyImages = images.Where(image => image.name.Contains("County")).ToList();
            startingColor.a = 0.1f;
            foreach (var image in _countyImages)
            {
                image.color = startingColor;
            }
            StartCoroutine(LoadGame());
            var syncBtn = syncButton.GetComponent<Button>();
            syncBtn.onClick.AddListener(() => { StartCoroutine(LoadGame()); });
            
            InvokeRepeating(nameof(StartCoroutineLoadGame), 2f, 1f);
        }
    
        IEnumerator LoadGame()
        {
            using var www = UnityWebRequest.Get("http://localhost:3000/game");
            yield return www.SendWebRequest();

            if (www.result == UnityWebRequest.Result.Success)
            {
                var json = JsonUtility.FromJson<SessionJson>(www.downloadHandler.text);
                var players = json.players;

                if (players.Length > 0)
                {
                    Debug.Log("Player 1: " + players[0].name + ", Points: " + players[0].points);
                    player1Name.text = players[0].name;
                    player1Points.text = players[0].points.ToString();
                    _countyImages[players[0].conqueredPlaces[0]].color = Color.red;
                }
                if (players.Length > 1)
                {
                    Debug.Log("Player 2: " + players[1].name + ", Points: " + players[1].points);
                    player2Name.text = players[1].name;
                    player2Points.text = players[1].points.ToString();
                    _countyImages[players[1].conqueredPlaces[0]].color = Color.green;
                }
                if (players.Length > 2)
                {
                    Debug.Log("Player 3: " + players[2].name + ", Points: " + players[2].points);
                    player3Name.text = players[2].name;
                    player3Points.text = players[2].points.ToString();
                    _countyImages[players[2].conqueredPlaces[0]].color = Color.blue;
                    
                    StartPhase1();
                }
            }
            else
            {
                Debug.Log("Error: " + www.error);
            }
        }
        
        void StartCoroutineLoadGame()
        {
            StartCoroutine(LoadGame());
        }
        
        void StartPhase1()
        {
            messageText.text = "Phase 1: Players are joining...";
            
        }

        // Update is called once per frame
        void Update()
        {
        
        }

        private void FixedUpdate()
        {
            // Update the timer text every second
            
        }
    }
}
