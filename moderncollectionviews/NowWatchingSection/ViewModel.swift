//
//  ViewModel.swift
//  moderncollectionviews
//
//  Created by Jazmine Paola Barroga on 10/29/20.
//  Copyright © 2020 jazminebarroga. All rights reserved.
//

import Foundation

protocol ViewModelDelegate: class {
    func didFinishGeneratingTrendingKdramas()
}

class ViewModel {
    var nowWatching = [KDrama]()
    
    var recommendedKdramas = [KDrama]()
    
    var trendingKdramas = [KDrama]()
    
    var timer: Timer?
    
    weak var delegate: ViewModelDelegate?
    
    init() {
    
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(shuffleTrendingKdramas), userInfo: nil, repeats: true)
        
        generateTrendingKdramas()
        generateKdramas()
        generateRecommendedKdramas()
    }
    
    private func generateKdramas() {
        nowWatching = [
            KDrama(title: "Start-Up", subtitle: "Young entrepreneurs aspiring to launch virtual dreams into reality compete for success and love in the cutthroat world of Korea's high-tech industry.", image: "start-up-banner", detail: nil),
            KDrama(title: "Prison Playbook", subtitle: "Baseball pitcher Kim Je-hyeok becomes a convict overnight after being sent to prison for defending his sister from a sexual assault, days before he was due to fly to the US to join the Boston Red Sox.", image: "prison-playbook-banner", detail: nil)
        ]
        
    }
    
    private func generateRecommendedKdramas() {
        recommendedKdramas = [
            KDrama(title: "SKY Castle", subtitle: "A satirical drama that closely looks at the materialistic desires of the upper-class parents in South Korea and how they ruthlessly secure the successes of their families at the cost of destroying others' lives.", image: nil, detail: [
                KDramaDetail(title: "🎥 Genre", value: "Dark Comedy, Satire, Drama"),
                KDramaDetail(title: "💁🏻‍♀️ Cast", value: "Yoon Se-ah, Kim Seo-hyung, Yum Jung-ah, Kim Hye-yoon"),
                KDramaDetail(title: "🏆 Awards", value: "Baeksang Arts Award for Best Leading Actress in TV")
                ]),
            KDrama(title: "My Mister", subtitle: "A man in his 40's withstands the weight of life. A woman in her 20's goes through different experiences, but also withstands the weight of her life. The man and woman get together to help each other.", image: nil, detail: [
                KDramaDetail(title: "🎥 Genre", value: "Drama"),
                KDramaDetail(title: "💁🏻‍♀️ Cast", value: "IU, Lee Sun Gyun, Jang Ki-yong, Kim Yeong-min, Park Ho-san"),
                KDramaDetail(title: "🏆 Awards", value: "Baeksang Arts Award for Best TV Script, Baeksang Arts Award for Best TV Drama")
                ]),
            KDrama(title: "Kingdom", subtitle: "While strange rumors about their ill King grip a kingdom, the crown prince becomes their only hope against a mysterious plague overtaking the land.", image: nil, detail: [
                KDramaDetail(title: "🎥 Genre", value: "Historical drama, Political drama, Horror, Thriller"),
                KDramaDetail(title: "💁🏻‍♀️ Cast", value: "Jeon Seok-ho, Kim Sang-ho, Ju Ji-hoon, Jun Ji-hyun"),
                KDramaDetail(title: "🏆 Awards", value: "None")
                ]),
            KDrama(title: "Romantic Doctor, Teacher Kim", subtitle: "Kim Sa Bu once gained fame as a top surgeon at a huge hospital.", image: "none", detail: [
                KDramaDetail(title: "🎥 Genre", value: "Medical drama, Melodrama, Romance"),
                KDramaDetail(title: "💁🏻‍♀️ Cast", value: "Han Suk-kyu, Seo Hyun-jin, Yoo Yeon-seok, Kim Min-jae, Yang Se-jong"),
                KDramaDetail(title: "🏆 Awards", value: "SBS Drama Award for Best Couple")
                ]),
            KDrama(title: "Guardian: The Lonely and Great God", subtitle: "In his quest for a bride to break his immortal curse, Dokkaebi, a 939-year-old guardian of souls, meets a grim reaper and a sprightly student with a tragic past.", image: nil, detail: [
                KDramaDetail(title: "🎥 Genre", value: "Romance, Drama"),
                KDramaDetail(title: "💁🏻‍♀️ Cast", value: "Gong Yoo Lee Dong-wook, Kim Go-eun, Yoo In-na"),
                KDramaDetail(title: "🏆 Awards", value: "None")
                ])
        ]
    }
    
    private func generateTrendingKdramas() {
        trendingKdramas = [KDrama(title: "It's Okay Not To Be Okay", subtitle: "", image: "iontbo-poster", detail: nil),
                           KDrama(title: "My Mister", subtitle: "", image: "my-mister-poster", detail: nil),
                           KDrama(title: "Record of Youth", subtitle: "", image: "record-of-youth-poster", detail: nil),
                           KDrama(title: "Reply 1988", subtitle: "", image: "reply-1988-poster", detail: nil),
                           KDrama(title: "Romantic 2", subtitle: "", image: "romantic-2-poster", detail: nil),
                           KDrama(title: "When Camellia Blooms", subtitle: "", image: "when-camellia-blooms-poster", detail: nil),
                           KDrama(title: "World of Married", subtitle: "", image: "world-of-married-poster", detail: nil)
        ].shuffled()
        
        delegate?.didFinishGeneratingTrendingKdramas()
    }
    
    @objc private func shuffleTrendingKdramas() {
        trendingKdramas = trendingKdramas.shuffled()
        delegate?.didFinishGeneratingTrendingKdramas()

    }
}
