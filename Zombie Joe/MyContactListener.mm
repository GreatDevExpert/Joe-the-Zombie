#import "MyContactListener.h"
#import "Level6.h"

MyContactListener::MyContactListener() : _contacts() {
}

MyContactListener::~MyContactListener() {
}

void MyContactListener::BeginContact(b2Contact* contact)
{
    // We need to copy out the data because the b2Contact passed in is reused.
    MyContact myContact = { contact->GetFixtureA(), contact->GetFixtureB() };
    _contacts.push_back(myContact);
    
    contact->SetEnabled(false);
}

void MyContactListener::EndContact(b2Contact* contact)
{
    MyContact myContact = { contact->GetFixtureA(), contact->GetFixtureB() };
    
    std::vector<MyContact>::iterator pos;
    pos = std::find(_contacts.begin(), _contacts.end(), myContact);
    
    if (pos != _contacts.end())
    {
        _contacts.erase(pos);
    }
    
    
//    b2Body* platformBody = platformFixture->GetBody();
//    b2Body* otherBody = otherFixture->GetBody();
//    
//    int numPoints = contact->GetManifold()->pointCount;
//    b2WorldManifold worldManifold;
//    contact->GetWorldManifold( &worldManifold );
//    
//    //check if contact points are moving downward
//    for (int i = 0; i < numPoints; i++)
//    {
//        b2Vec2 pointVel = otherBody->GetLinearVelocityFromWorldPoint( worldManifold.points[i] );
//        if ( pointVel.y < 0 )
//            return;     //point is moving down, leave contact solid and exit
//    }
    
    //no points are moving downward, contact should not be solid
    //contact->SetEnabled(false);
}

void MyContactListener::PreSolve(b2Contact* contact, const b2Manifold* oldManifold) {
}

void MyContactListener::PostSolve(b2Contact* contact, const b2ContactImpulse* impulse) {
}