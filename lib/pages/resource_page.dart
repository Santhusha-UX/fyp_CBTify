// ignore_for_file: unnecessary_to_list_in_spreads, use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lottie/lottie.dart';

class ResourcesScreen extends StatelessWidget {
  ResourcesScreen({super.key});

  // Expanded list of resource categories
  final List<Category> categories = [
    Category(
      name: "CBT Fundamentals",
      resources: [
        Resource(title: "Introduction to CBT", description: "A beginner's guide to Cognitive Behavioral Therapy.", link: "https://www.psychologytoday.com/us/basics/cognitive-behavioral-therapy", type: ResourceType.article),
        Resource(title: "CBT Techniques", description: "Effective techniques used in Cognitive Behavioral Therapy.", link: "https://www.verywellmind.com/what-is-cognitive-behavior-therapy-2795747", type: ResourceType.video),
      ],
    ),
    Category(
      name: "Anxiety Management",
      resources: [
        Resource(title: "Coping Strategies for Anxiety", description: "Learn how to manage and reduce anxiety.", link: "https://www.healthline.com/health/anxiety/anxiety-coping-strategies", type: ResourceType.article),
        Resource(title: "Breathing Techniques", description: "Breathing exercises to help you relax.", link: "https://www.health.harvard.edu/lung-health-and-disease/learning-diaphragmatic-breathing", type: ResourceType.infographic),
      ],
    ),
    Category(
      name: "Mindfulness",
      resources: [
        Resource(title: "Practicing Mindfulness", description: "A guide to integrating mindfulness into your daily life.", link: "https://www.mindful.org/how-to-practice-mindfulness/", type: ResourceType.article),
        Resource(title: "Mindfulness Meditation", description: "Techniques for mindfulness meditation.", link: "https://www.nytimes.com/guides/well/how-to-meditate", type: ResourceType.video),
      ],
    ),
    Category(
      name: "Depression",
      resources: [
        Resource(title: "Understanding Depression", description: "Exploring the symptoms and treatments for depression.", link: "https://www.nimh.nih.gov/health/topics/depression", type: ResourceType.article),
        Resource(title: "Self-Care for Depression", description: "Self-care strategies for dealing with depression.", link: "https://www.psychologytoday.com/us/blog/click-here-happiness/201901/self-care-strategies-depression", type: ResourceType.infographic),
      ],
    ),
    Category(
      name: "Sleep Hygiene",
      resources: [
        Resource(title: "Improving Your Sleep", description: "Tips for better sleep hygiene.", link: "https://www.sleepfoundation.org/sleep-hygiene", type: ResourceType.article),
        Resource(title: "The Science of Sleep", description: "Understanding how sleep works and its importance.", link: "https://www.ninds.nih.gov/Disorders/Patient-Caregiver-Education/Understanding-Sleep", type: ResourceType.video),
      ],
    ),
    Category(
      name: "Stress Reduction",
      resources: [
        Resource(title: "Stress Management Strategies", description: "Effective ways to manage stress.", link: "https://www.helpguide.org/articles/stress/stress-management.htm", type: ResourceType.infographic),
        Resource(title: "Yoga for Stress Relief", description: "Using yoga to combat stress.", link: "https://www.yogajournal.com/practice-section/yoga-for-stress-relief/", type: ResourceType.video),
      ],
    ),
    Category(
      name: "Healthy Eating",
      resources: [
        Resource(title: "Nutrition and Mental Health", description: "The connection between diet and mental health.", link: "https://www.mentalhealth.org.uk/a-to-z/d/diet-and-mental-health", type: ResourceType.article),
        Resource(title: "Healthy Eating Tips", description: "Simple tips for a healthier diet.", link: "https://www.eatforhealth.gov.au/eating-well/tips-eating-well", type: ResourceType.infographic),
      ],
    ),
  ];

  final List<Helpline> helplines = [
    Helpline(name: "National Mental Health Helpline", number: "1926", description: "24/7 National helpline for mental health support."),
    Helpline(name: "Sri Lanka Sumithrayo", number: "+94707308308", description: "Confidential support for anyone in crisis."),
    Helpline(name: "CCCline Foundation", number: "+94777915293", description: "Support for mental health and suicide prevention."),
    // Add more helplines as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Learn & Grow"),
        backgroundColor: Colors.deepPurple,
        shadowColor: Colors.white54,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListView(
          children: [
            _buildBanner(context),
            ...categories.map((category) => _buildCategoryCard(context, category)).toList(),
            const SizedBox(height: 10),
            const Divider(color: Colors.deepPurple, thickness: 2),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.emergency_rounded, color: Colors.red),
                      SizedBox(width: 8),
                      Text(
                        "Emergency Helplines",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "If you or someone you know is in need of immediate support, please reach out to one of these helplines.",
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 16),
                  ...helplines.map((helpline) => HelplineCard(helpline: helpline)).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.deepPurpleAccent,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.shade200.withOpacity(0.6),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Lottie.asset('assets/animations/resource.json',
              width: MediaQuery.of(context).size.width * 0.8, repeat: true),
          const Text(
            "Begin Your Learning Journey",
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Explore curated resources to enlighten your path towards mental wellness. Embrace the journey towards a  balanced life.',
            style:
                TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.9)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, Category category) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(10), // Uniform margin for better spacing
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ExpansionTile(
        iconColor: Colors.white,
        collapsedIconColor: Colors.grey.shade600,
        leading: const CircleAvatar(
          backgroundColor: Colors.deepPurpleAccent,
          child: Icon(Icons.folder_outlined, color: Colors.white),
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0), // Added padding for the title
          child: Text(
            category.name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        children: category.resources.map((resource) => _buildResourceTile(context, resource)).toList(),
      ),
    );
  }

  Widget _buildResourceTile(BuildContext context, Resource resource) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 10, left: 15, right: 15), // Reduced bottom padding for a tighter layout
      child: Container(
        decoration: BoxDecoration(
          color: Colors.deepPurpleAccent.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16), // Consistent padding inside ListTile
          leading: CircleAvatar(
            backgroundColor: ResourceTypeColors.getColor(resource.type),
            child: Icon(resource.type.icon, color: Colors.white),
          ),
          title: Text(
            resource.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            resource.description,
            style: TextStyle(
              fontSize: 14, // Adjusted for better readability
              color: Colors.grey[500],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () => _launchURL(context, resource.link),
        ),
      ),
    );
  }

  void _launchURL(BuildContext context, String url) async {
    if (!await canLaunch(url)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not launch $url')));
    } else {
      await launch(url);
    }
  }
}

class ResourceTypeColors {
  static Color getColor(ResourceType type) {
    switch (type) {
      case ResourceType.article:
        return Colors.blue.shade700;
      case ResourceType.video:
        return Colors.red.shade700;
      case ResourceType.infographic:
        return Colors.green.shade700;
      default:
        return Colors.deepPurple;
    }
  }
}

enum ResourceType { article, video, infographic }

extension on ResourceType {
  IconData get icon {
    switch (this) {
      case ResourceType.article:
        return Icons.article;
      case ResourceType.video:
        return Icons.play_circle_fill;
      case ResourceType.infographic:
        return Icons.insert_chart_outlined_rounded;
      default:
        return Icons.help_outline;
    }
  }
}

class Category {
  final String name;
  final List<Resource> resources;

  Category({required this.name, required this.resources});
}

class Resource {
  final String title;
  final String description;
  final String link;
  final ResourceType type;

  Resource({required this.title, required this.description, required this.link, required this.type});
}

class HelplineCard extends StatelessWidget {
  final Helpline helpline;

  const HelplineCard({
    super.key,
    required this.helpline,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(20),
        title: Text(helpline.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 2),
            Text(helpline.description, style: const TextStyle(fontSize: 12, color: Colors.white30)),
            const SizedBox(height: 8),
            Text(helpline.number, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepPurpleAccent)),
          ],
        ),
        trailing: const Icon(Icons.phone_in_talk, color: Colors.deepPurpleAccent),
      ),
    );
  }
}

class Helpline {
  final String name;
  final String number;
  final String description;

  Helpline({
    required this.name,
    required this.number,
    required this.description,
  });
}