#import "Box2D.h"
#import <vector>
#import <algorithm>

struct MyContactS {
    b2Fixture *fixtureA;
    b2Fixture *fixtureB;
    bool operator==(const MyContactS& other) const
    {
        return (fixtureA == other.fixtureA) && (fixtureB == other.fixtureB);
    }
    };
    
    class MyContactListenerS : public b2ContactListener {
        
    public:
        std::vector<MyContactS>_contacts;
        
        MyContactListenerS();
        ~MyContactListenerS();
        
        virtual void BeginContact(b2Contact* contact);
        virtual void EndContact(b2Contact* contact);
        virtual void PreSolve(b2Contact* contact, const b2Manifold* oldManifold);
        virtual void PostSolve(b2Contact* contact, const b2ContactImpulse* impulse);
        
    };